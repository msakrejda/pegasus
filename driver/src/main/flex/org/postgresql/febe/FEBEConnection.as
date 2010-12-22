package org.postgresql.febe {

    import flash.events.Event;

    import org.postgresql.CodecError;
    import org.postgresql.InvalidStateError;
    import org.postgresql.ProtocolError;
    import org.postgresql.UnsupportedProtocolFeatureError;
    import org.postgresql.febe.message.AuthenticationRequest;
    import org.postgresql.febe.message.BackendKeyData;
    import org.postgresql.febe.message.CancelRequest;
    import org.postgresql.febe.message.CommandComplete;
    import org.postgresql.febe.message.DataRow;
    import org.postgresql.febe.message.EmptyQueryResponse;
    import org.postgresql.febe.message.ErrorResponse;
    import org.postgresql.febe.message.IBEMessage;
    import org.postgresql.febe.message.IFEMessage;
    import org.postgresql.febe.message.NoticeResponse;
    import org.postgresql.febe.message.NotificationResponse;
    import org.postgresql.febe.message.ParameterStatus;
    import org.postgresql.febe.message.PasswordMessage;
    import org.postgresql.febe.message.Query;
    import org.postgresql.febe.message.ReadyForQuery;
    import org.postgresql.febe.message.ResponseMessageBase;
    import org.postgresql.febe.message.RowDescription;
    import org.postgresql.febe.message.StartupMessage;
    import org.postgresql.febe.message.Terminate;
    import org.postgresql.log.ILogger;
    import org.postgresql.log.Log;
    import org.postgresql.util.assert;

    // A FEBEConnection can execute one statement at a time (when it is rfq).
    // It does not do any parameter encoding or result set decoding: these
    // are passed through as binary payloads, with decoding to be done at
    // a higher level.
    public class FEBEConnection {

        private static const LOGGER:ILogger = Log.getLogger(FEBEConnection);

        private var _params:Object;

        private var _streamFactory:MessageStreamFactory;
        private var _stream:IMessageStream;
        private var _messageHandler:MessageHandler;

        private var _authenticated:Boolean;
        private var _connecting:Boolean;
        private var _connected:Boolean;

        private var _rfq:Boolean;
        private var _status:String;

        private var _queryHandler:IQueryHandler;
        private var _currResults:Array;
        private var _hasCodecError:Boolean;

        private var _password:String;

        private var _connHandler:IConnectionHandler;

        private var _backendPid:int;
        private var _backendKey:int;

        public var serverParams:Object;


        // Note that params here are params we want to send to the server in the
        // startup packet. The jdbc driver sends this:
        // {
        //      user: user,
        //      database: database,
        //      client_encoding: "UNICODE",
        //      DateStyle: "ISO"
        // };
        // Furthermore, we need the password if we're doing authentication that
        // involves a password. Jdbc also passes in a flag to use SSL here, but
        // it could be handy to handle that in the message broker factory

        public function FEBEConnection(params:Object, password:String, streamFactory:MessageStreamFactory) {
            _params = params;
            _streamFactory = streamFactory;

            _connected = false;
            _connecting = true;
            _authenticated = false;

            _queryHandler = null;
            _hasCodecError = false;
            _currResults = [];

            _password = password;

            serverParams = {};
            _backendKey = -1;
            _backendPid = -1;
        }

        public function get rfq():Boolean {
            return _rfq;
        }

        public function get status():String {
            return _status;
        }

        public function connect(handler:IConnectionHandler):void {
            if (_connected) {
                onProtocolError(new ProtocolError("Already connected"));
            }
            _connHandler = handler;
            _connecting = true;

            _stream = _streamFactory.create();
            _messageHandler = new MessageHandler(_stream);
            // TODO: This is a little ugly, especially since the underlying
            // data stream can theoretically give up the ghost before this
            // step happens. In practice, that's not likely due to Flash
            // Player's asynchronous execution model, but it'd be nice to fix.
            _stream.addEventListener(MessageStreamErrorEvent.ERROR, handleStreamError);
            _stream.addEventListener(MessageStreamEvent.BATCH_COMPLETE, handleBatchComplete);

            _messageHandler.setMessageListener(AuthenticationRequest, handleAuth);
            _messageHandler.setMessageListener(BackendKeyData, handleKeyData);
            _messageHandler.setMessageListener(ParameterStatus, handleParam);
            _messageHandler.setMessageListener(NoticeResponse, handleNotice);
            _messageHandler.setMessageListener(ErrorResponse, handleError);
            _messageHandler.setMessageListener(ReadyForQuery, handleFirstRfq);

            send(new StartupMessage(_params));
        }

        private function send(msg:IFEMessage):void {
            if (_connected || (_connecting && (msg is StartupMessage || msg is PasswordMessage))) {
                try {
                    _stream.send(msg);
                } catch (e:Error) {
                    _connHandler.handleStreamError(e);
                }
            } else {
                _connHandler.handleStreamError(new InvalidStateError("Connection closed"));
            }
        }

        private function handleUnexpectedMessage(msg:IBEMessage):void {
            onProtocolError(new ProtocolError("Unexpected message: " + msg.type));
        }

        private function handleAuth(msg:AuthenticationRequest):void {
            // TODO: more auth types
            if (msg.subtype == AuthenticationRequest.OK) {
                _authenticated = true;
            } else if (msg.subtype == AuthenticationRequest.CLEARTEXT_PASSWORD) {
                send(new PasswordMessage(_password));
            } else {
                onProtocolError(new UnsupportedProtocolFeatureError(
                    "Unsupported authentication type requested: " + msg.subtype));
            }
        }

        private function handleFirstRfq(msg:ReadyForQuery):void {
            if (_authenticated) {
                _connecting = false;
                _connected = true;

                _messageHandler.setMessageListener(ReadyForQuery, handleRfq);
                _messageHandler.setMessageListener(AuthenticationRequest, handleUnexpectedMessage);
                _messageHandler.setMessageListener(BackendKeyData, handleUnexpectedMessage);

                _messageHandler.setMessageListener(NotificationResponse, handleNotification);
                _messageHandler.setMessageListener(RowDescription, handleMetadata);
                _messageHandler.setMessageListener(DataRow, handleData);
                // _broker.setMessageListener(CopyInResponse, ...);
                // _broker.setMessageListener(CopyOutResponse, ...);
                _messageHandler.setMessageListener(CommandComplete, handleComplete);
                _messageHandler.setMessageListener(EmptyQueryResponse, handleEmpty);

                _connHandler.handleConnected();
                handleRfq(msg);
            } else {
                onProtocolError(new ProtocolError("Unexpected ReadyForQuery without AuthenticationOK"));
            }
        }

        private function handleKeyData(msg:BackendKeyData):void {
            _backendKey = msg.key;
            _backendPid = msg.pid;
        }

        private function handleParam(msg:ParameterStatus):void {
            serverParams[msg.name] = msg.value;
            if (_connected) {
               _connHandler.handleParameterChange(msg.name, msg.value);
            }
        }

        private function handleRfq(msg:ReadyForQuery):void {
            _rfq = true;
            _status = msg.status;
            _connHandler.handleReady(_status);
        }

        private function handleNotification(msg:NotificationResponse):void {
            _connHandler.handleNotification(msg.condition, msg.notifierPid);
        }

        private function handleNotice(msg:ResponseMessageBase):void {
            _connHandler.handleNotice(msg.fields);
        }

        private function handleError(msg:ErrorResponse):void {
            _connHandler.handleSQLError(msg.fields);
            if (_queryHandler) {
                _queryHandler.dispose();
                _queryHandler = null;
            }
        }

        private function handleMetadata(msg:RowDescription):void {
            if (_queryHandler) {
                assert("Unexpected data remaining in result buffer", _currResults.length == 0);
                try {
                    _queryHandler.handleMetadata(msg.fields);
                } catch (e:CodecError) {
                    onCodecError(e);
                }
            } else {
                onProtocolError(new ProtocolError('Unexpected RowDescription message'));
            }
        }

        private function handleData(msg:DataRow):void {
            if (_queryHandler) {
                _currResults.push(msg.rowBytes);
            } else if (_hasCodecError) {
                /* do nothing; just drop */
            } else {
                onProtocolError(new ProtocolError('Unexpected DataRow message'));
            }
        }

        private function handleComplete(msg:CommandComplete):void {
            if (_queryHandler) {
                flushPendingResults();
                _queryHandler.handleCompletion(msg.command, msg.affectedRows, msg.oid);
                _queryHandler.dispose();
                _queryHandler = null;
            } else if (_hasCodecError) {
                _hasCodecError = false;
            } else {
                onProtocolError(new ProtocolError("Unexpected CommandComplete"));
            }
        }

        private function handleEmpty(msg:EmptyQueryResponse):void {
            // This is equivalent to CommandComplete when an empty query completes.
            // Let's call this a query completing successfully. Theoretically, we may want
            // to handle this differently, but there's little practical use for that.
            if (_queryHandler) {
                _queryHandler.handleCompletion('EMPTY QUERY');
                _queryHandler = null;
            } else {
                onProtocolError(new ProtocolError("Unexpected EmptyQueryResponse"));
            }
        }

        private function flushPendingResults():void {
            if (_queryHandler && _currResults.length > 0) {
                try {
                    _queryHandler.handleData(_currResults, serverParams);
                    _currResults = [];
                } catch (e:CodecError) {
                     onCodecError(e);
                }
            }
        }

        private function handleBatchComplete(e:Event):void {
            flushPendingResults();
        }

        // Methods executeSimpleQuery and executeQuery should both notify caller when commandComplete
        // returns a result set. When rfq, the nesting Connection should issue another query.

        // Since these will only have one outstanding statement at any given time, perhaps
        // we should keep that as a member variable while the call is being executed. We
        // need to have some concept of 'outstanding statement' (which could lead to more
        // than one result set for a simple query), and we still need to process notices
        // and notifications while this happens. We also need to figure out what events
        // to dispatch in this case.

        // To future-proof against result set streaming, we should dispatch separate
        // query-data-available and statement-complete messages. We should also batch
        // the data-available messages--dispatching an event per-DataRow would be silly.
        public function executeSimpleQuery(sql:String, handler:IQueryHandler):void {
            ensureConnected();
            ensureReady();
            _rfq = false;
            _queryHandler = handler;
            send(new Query(sql));
        }

        public function executeQuery(sql:String, params:Array, handler:IQueryHandler):void {
            ensureConnected();
            ensureReady();
            // > parse(statement)
            // < parseComplete | errorResponse
            // > bind(portal)
            // < bindComplete | errorResponse
            // > describe(portal)
            // < rowDescription
            // > execute(portal)
            // < commandComplete | errorResponse | emptyQueryResponse | portalSuspended
            // > sync
        }

        // additionally, there is fastpath (function call) and copy. It might be handy to
        // support a structured explain

        public function cancel():void {
            ensureConnected();
            // Note that cancel needs to happen in a separate connection to make any sense.
            // Since the broker goes out of scope here as soon as the method body ends,
            // there may be some issues with GC (since socket communication is asynchronous),
            // but Flash Player *should* queue everything it needs to do the physical send
            // before GC. To do this right, we'd probably have to keep a reference to this
            // broker and listen for close (or error) and only remove the reference then
            try {
                var cancelStream:IMessageStream = _streamFactory.create();
                cancelStream.send(new CancelRequest(_backendPid, _backendKey));
                try {
                    cancelStream.close();
                } catch (e:Error) {
                    LOGGER.warn("Could not close cancel broker: " + e.message);
                }
            } catch (e:Error) {
                LOGGER.warn("Could not cancel statement: " + e.message);
            }
        }

        private function handleStreamError(e:MessageStreamErrorEvent):void {
            close();
            _connHandler.handleStreamError(new Error("Error event: " + e.text));
        }

        public function close():void {
            if (_connected) {
                if (_stream.connected) {
                    try {
                        _stream.send(new Terminate());
                        _stream.close();
                    } catch (e:Error) {
                        LOGGER.warn("Could not shut down cleanly: " + e.message);
                    }
                }
                _connected = false;
            }
        }

        private function onProtocolError(error:ProtocolError):void {
            // We don't know what the heck is going on. Bail.
            close();
            _connHandler.handleProtocolError(error);
        }

        private function onCodecError(error:CodecError):void {
            // The query dies, but the connection is fine
            _connHandler.handleCodecError(error);
            _queryHandler.dispose();
            _queryHandler = null;
            // Note that we still may need to throw away any number of DataRow messages
            _hasCodecError = true;
        }

        private function ensureConnected():void {
            if (!_connected) {
                _connHandler.handleStreamError(new Error("Not connected"));
            }
        }

        private function ensureReady():void {
            if (!_rfq) {
                onProtocolError(new ProtocolError("FEBEConnection is not ready for query"));
            }
        }

    }
}

import flash.utils.Dictionary;
import org.postgresql.febe.IMessageStream;
import org.postgresql.febe.MessageEvent;
import org.postgresql.febe.message.IBEMessage;
import org.postgresql.util.assert;
import org.postgresql.log.ILogger;
import org.postgresql.log.Log;
import org.postgresql.febe.IMessageStream;

/**
 * Helper class for reading messages. Note that this is not a full wrapper
 * around the broker; it's just a simple facility of installing and removing
 * message listeners.
 */
class MessageHandler {

    private static const LOGGER:ILogger = Log.getLogger(MessageHandler);

    private var _msgListeners:Dictionary;
    private var _stream:IMessageStream;

    public function MessageHandler(stream:IMessageStream) {
        _msgListeners = new Dictionary();
        _stream = stream;
        _stream.addEventListener(MessageEvent.RECEIVED, handleMessageReceived);
    }

    private function handleMessageReceived(e:MessageEvent):void {
        var msg:IBEMessage = IBEMessage(e.message);
        assert("No message associated with message event", msg);
        if (Object(msg).constructor in _msgListeners) {
            var listener:Function = _msgListeners[Object(msg).constructor];
            if (listener != null) {
                listener(msg);
            } else {
                LOGGER.warn("No message listener associated with message {0}; dropping", msg);
            }
        }
    }

    public function setMessageListener(msg:Class, callback:Function):void {
        _msgListeners[msg] = callback;
    }

    public function clearMessageListener(msg:Class):void {
        delete _msgListeners[msg];
    }
}