package org.postgresql.febe {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.postgresql.event.NoticeEvent;
	import org.postgresql.event.NotificationEvent;
	import org.postgresql.febe.message.AuthenticationRequest;
	import org.postgresql.febe.message.BackendKeyData;
	import org.postgresql.febe.message.CommandComplete;
	import org.postgresql.febe.message.DataRow;
	import org.postgresql.febe.message.EmptyQueryResponse;
	import org.postgresql.febe.message.ErrorResponse;
	import org.postgresql.febe.message.IBEMessage;
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

    // A FEBEConnection can execute one statement at a time (when it is rfq).
    // It does not do any parameter encoding or result set decoding: these
    // are passed through as binary payloads, with decoding to be done at
    // a higher level.
	public class FEBEConnection extends EventDispatcher {

        public static const CONNECTED:String = 'connected';
        public static const PARAM_CHANGE:String = 'paramChange';
        public static const READY_FOR_QUERY:String = 'readyForQuery';

        private static const LOGGER:ILogger = Log.getLogger("org.postgresql.db.Connection");

		private var _params:Object;

        private var _brokerFactory:MessageBrokerFactory;
		private var _broker:MessageBroker;
		// Note that we may have multiple outstanding queries, but
		// we'll only want to cancel at most one
        private var _cancelBroker:MessageBroker;

        private var _authenticated:Boolean;
        private var _connecting:Boolean;
        private var _connected:Boolean;

        private var _rfq:Boolean;
        private var _status:String;

        private var _queryHandler:IQueryHandler;
        private var _currResults:Array;

        private var _password:String;

	    public var backendPid:int;
	    public var backendKey:int;
	
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

		public function FEBEConnection(params:Object, password:String, brokerFactory:MessageBrokerFactory) {
			_params = params;
            _brokerFactory = brokerFactory;
            // Our main broker
            _broker = brokerFactory.create();

            _connected = false;
            _connecting = false;
            _authenticated = false;

            _queryHandler = null;
            _currResults = [];
            
            _password = password;

            serverParams = {};
            backendKey = -1;
            backendPid = -1;
		}

        public function get rfq():Boolean {
        	return _rfq;
        }

        public function get status():String {
        	return _status;
        }

        public function connect():void {
        	// TODO: support disconnect / reconnect
        	_broker.setMessageListener(AuthenticationRequest, handleAuth);
        	_broker.setMessageListener(BackendKeyData, handleKeyData);
        	_broker.setMessageListener(ParameterStatus, handleParam);
        	_broker.setMessageListener(NoticeResponse, handleNotice);
        	_broker.setMessageListener(ErrorResponse, handleError);
        	_broker.setMessageListener(ReadyForQuery, handleFirstRfq);

        	_broker.addEventListener(MessageBroker.BATCH_COMPLETE, handleBatchComplete);

            _broker.send(new StartupMessage(_params));
        }

        private function handleUnexpectedMessage(msg:IBEMessage):void {
            // TODO: this should probably be an error event since it's
            // happening asynchronously
        	throw new ProtocolError("Unexpected message: " + msg.type);
        }
	
	    private function handleAuth(msg:AuthenticationRequest):void {
	        if (msg.subtype == AuthenticationRequest.OK) {
	            _authenticated = true;
	        } else if (msg.subtype == AuthenticationRequest.CLEARTEXT_PASSWORD) {
	            _broker.send(new PasswordMessage(_password));
	        } else {
	            throw new ProtocolError("Unsupported authentication type requested");                   
	        }
	    }

        private function handleFirstRfq(msg:ReadyForQuery):void {
            if (_authenticated) {
                _connecting = false;
                _connected = true;
                _rfq = true;
                _status = msg.status;

                _broker.setMessageListener(ReadyForQuery, handleRfq);
                _broker.setMessageListener(AuthenticationRequest, handleUnexpectedMessage);
                _broker.setMessageListener(BackendKeyData, handleUnexpectedMessage);

                _broker.setMessageListener(NotificationResponse, handleNotification);
                _broker.setMessageListener(RowDescription, handleMetadata);
                _broker.setMessageListener(DataRow, handleData);
                // _broker.setMessageListener(CopyInResponse, ...);
                // _broker.setMessageListener(CopyOutResponse, ...);
                _broker.setMessageListener(CommandComplete, handleComplete);
                _broker.setMessageListener(EmptyQueryResponse, handleEmpty);

                dispatchEvent(new Event(READY_FOR_QUERY));
                dispatchEvent(new Event(CONNECTED));
            } else {
                throw new ProtocolError("Unexpected ReadyForQuery without AuthenticationOK"); 
            }
        }
	
	    private function handleKeyData(msg:BackendKeyData):void {
	        backendKey = msg.key;
	        backendPid = msg.pid;
	    }
	
	    private function handleParam(msg:ParameterStatus):void {
	        serverParams[msg.name] = msg.value;
	        if (_connected) {
	           dispatchEvent(new Event(PARAM_CHANGE));
	        }
	    }
	
	    private function handleRfq(msg:ReadyForQuery):void {
	        _rfq = true;
	        _status = msg.status;
	        dispatchEvent(new Event(READY_FOR_QUERY));
	    }
	
	    private function handleNotification(msg:NotificationResponse):void {
	        dispatchEvent(new NotificationEvent(msg.condition, msg.notifierPid));
	    }
	
	    private function handleNotice(msg:ResponseMessageBase):void {
	    	if (_queryHandler) {
    			_queryHandler.handleNotice(msg.fields);
	    	} else {
	           dispatchEvent(new NoticeEvent(NoticeEvent.NOTICE, msg.fields));
            }
	    }

        private function handleError(msg:ErrorResponse):void {
            if (_queryHandler) {
                _queryHandler.handleError(msg.fields);
            } else {
               for (var key:String in msg.fields) {
                   trace(key, msg.fields[key]);
               }
               dispatchEvent(new NoticeEvent(NoticeEvent.ERROR, msg.fields));
            }        	
        }
	
	    private function handleMetadata(msg:RowDescription):void {
	        if (_queryHandler) {
	        	_queryHandler.handleMetadata(msg.fields);
	        } else {
	        	throw new ProtocolError('Unexpected RowDescription message');
	        }
	    }
	
	    private function handleData(msg:DataRow):void {
	        if (_queryHandler) {
	        	_currResults.push(msg.rowBytes);
	        } else {
	        	throw new ProtocolError('Unexpected DataRow message');
	        }
	    }
	
	    private function handleComplete(msg:CommandComplete):void {
	        if (_queryHandler) {
	        	flushPendingResults();
	        	_queryHandler.handleCompletion(msg.commandTag, msg.affectedRows, msg.oid);
	        	_queryHandler = null;
	        } else {
	        	throw new ProtocolError("Unexpected CommandComplete"); 
	        }
	    }
	
	    private function handleEmpty(msg:EmptyQueryResponse):void {
	        // this is equivalent to CommandComplete when an empty let's pretend
	        // that the query completed successfully. Theoretically, we may want
	        // to handle this differently, but there's little practical use for that.
	        if (_queryHandler) {
	        	_queryHandler.handleCompletion('EMPTY QUERY');
	        	_currResults = [];
	        	_queryHandler = null;
	        } else {
	        	throw new ProtocolError("Unexpected EmptyQueryResponse");
	        }
	    }

        private function flushPendingResults():void {
            if (_queryHandler && _currResults.length > 0) {
                _queryHandler.handleData(_currResults, serverParams);
                _currResults = [];
            }
        }

        private function handleBatchComplete(e:Event):void {
        	flushPendingResults();
        }

        // executeSimpleQuery and executeQuery should both notify caller when commandComplete
        // returns a result set. when rfq, the nesting Connection should issue another query.

        // since these will only have one outstanding statement at any given time, perhaps
        // we should keep that as a member variable while the call is being executed. We
        // need to have some concept of 'outstanding statement' (which could lead to more
        // than one result set for a simple query), and we still need to process notices
        // and notifications while this happens. We also need to figure out what events
        // to dispatch in this case.

        // To future-proof against result set streaming, we should dispatch separate
        // query-data-available and statement-complete messages. We should also batch
        // the data-available messages--dispatching an event per-DataRow would be silly.
        public function executeSimpleQuery(sql:String, handler:IQueryHandler):void {
        	if (!_rfq) {
        		throw new ArgumentError("FEBEConnection is not ready for query");
        	}
            _queryHandler = handler;
            _broker.send(new Query(sql));
        }

        public function executeQuery():void {
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

        public /* ? */ function cancel():void {
            // probably want to do this per-query instead, and possibly add something
            // like a 'clear()' to cancel all pending queries
        }

        public function close():void {
            if (_connected) {
                _broker.send(new Terminate());                
            }
        }

	}
}