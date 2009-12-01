package org.postgresql.db {

    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;

    import mx.logging.ILogger;
    import mx.logging.Log;

    import org.postgresql.codec.TypeCodecFactory;
    import org.postgresql.febe.MessageBroker;
    import org.postgresql.febe.MessageEvent;
    import org.postgresql.febe.ProtocolError;
    import org.postgresql.febe.message.AuthenticationRequest;
    import org.postgresql.febe.message.BackendKeyData;
    import org.postgresql.febe.message.ParameterStatus;
    import org.postgresql.febe.message.Query;
    import org.postgresql.febe.message.ReadyForQuery;
    import org.postgresql.febe.message.StartupMessage;
    import org.postgresql.febe.message.Terminate;

    public class Connection extends EventDispatcher {

        private static const LOGGER:ILogger = Log.getLogger("org.postgresql.db.Connection");

        private var _codecs:TypeCodecFactory;
        private var _params:Object;
        private var _broker:MessageBroker;

        private var _rfq:Boolean;
        private var _transactionStatus:String;

        private var _active:Dictionary;
        private var _pendingExecution:Array;
        private var _pendingResult:Array;

        private var _connected:Boolean;
        private var _serverParams:Object;

        private var _backendPid:int;
        private var _backendKey:int;

        public function Connection(params:Object, broker:MessageBroker, codecs:TypeCodecFactory) {
            _params = params;
            _broker = broker;
            _codecs = codecs;

            // add listeners to the broker for rfq, auth handling, paramStatus, backendKeyData,
            // rowDescription, dataRow, commandComplete

            // split different chunks of functionality? authenticator, {simple,extended}QueryExecutor,
            // copy, function call, cancel, terminate

            _connected = false;
            _rfq = false;
            _serverParams = {};
            // the first rfq will update this
            _transactionStatus = 'invalid';

            _active = new Dictionary();
            _pendingExecution = [];
            _pendingResult = [];

            _broker.addMessageListener(AuthenticationRequest, handleAuthenticationRequest);
            _broker.addMessageListener(BackendKeyData, handleBackendKeyData);
            _broker.addMessageListener(ParameterStatus, handleServerParameter);
            _broker.addMessageListener(ReadyForQuery, handleReadyForQuery);
            _broker.send(new StartupMessage(_params));
        }

        public function close():void {
            if (!_connected) {
                throw new Error("Already disconnected");
            }
            _broker.send(new Terminate());
        }

        private function handleReadyForQuery(e:MessageEvent):void {
            _transactionStatus = ReadyForQuery(e.message).status;
            _rfq = true;
            if (!_connected) {
                _connected = true;
                dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTED));
            }
        }

        private function handleBackendKeyData(e:MessageEvent):void {
            var msg:BackendKeyData = BackendKeyData(e.message);
            _backendKey = msg.key;
            _backendPid = msg.pid;
            _broker.removeMessageListener(BackendKeyData, handleBackendKeyData);
        }

        private function handleServerParameter(e:MessageEvent):void {
            var msg:ParameterStatus = ParameterStatus(e.message);
            if (msg.name in _serverParams) {
                LOGGER.debug("Udating server parameter " + msg.name + " from " +
                    _serverParams[msg.name] + " to " + msg.value);
            }
            _serverParams[msg.name] = msg.value;
        }

        private function handleAuthenticationRequest(e:MessageEvent):void {
            var authMsg:AuthenticationRequest = AuthenticationRequest(e.message);
            if (authMsg.subtype == AuthenticationRequest.OK) {
                _broker.removeMessageListener(AuthenticationRequest, handleAuthenticationRequest);
                // We don't dispatch the CONNECTED event unitl the first RFQ
            } else {
                throw new ProtocolError("Unsupported authentication type requested");
            }
        }

        public function createStatement():IStatement {
            var s:IStatement = new SimpleStatement(this);
            _active[s] = true;
            return s;
        }

        internal function executeQuery(statement:IStatement, sql:String):void {
            if (!(statement in _active)) {
                throw new ArgumentError("Attempting to execute unregistered statement: " + statement);
            }

            if (_rfq) {
                _rfq = false;
                _broker.send(new Query(sql));
                _pendingResult.push({ statement: statement, sql: sql });
            } else {
                _pendingExecution.push({ statement: statement, sql: sql });
            }
        }

        internal function closeStatement(statement:IStatement):void {
            if (!(statement in _active)) {
                throw new ArgumentError("Attempting to close unregistered statement: " + statement);
            }

            delete _active[statement];
        }


    }
}