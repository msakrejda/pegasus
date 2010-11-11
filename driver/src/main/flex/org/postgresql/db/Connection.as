package org.postgresql.db {

    import flash.events.EventDispatcher;
    
    import org.postgresql.CodecError;
    import org.postgresql.ProtocolError;
    import org.postgresql.event.CodecErrorEvent;
    import org.postgresql.event.ConnectionEvent;
    import org.postgresql.event.NoticeEvent;
    import org.postgresql.event.NotificationEvent;
    import org.postgresql.event.ParameterChangeEvent;
    import org.postgresql.event.ProtocolErrorEvent;
    import org.postgresql.febe.FEBEConnection;
    import org.postgresql.febe.IConnectionHandler;
    import org.postgresql.febe.IQueryHandler;
    import org.postgresql.log.ILogger;
    import org.postgresql.log.Log;

    public class Connection extends EventDispatcher implements IConnection, IConnectionHandler {

        private static const LOGGER:ILogger = Log.getLogger(Connection);

        private var _baseConn:FEBEConnection;
        private var _queryHandlerFactory:QueryHandlerFactory;

        private var _pendingExecution:Array;
        private var _currentHandler:IQueryHandler;
        private var _currentToken:QueryToken;

        public function Connection(baseConn:FEBEConnection, queryHandlerFactory:QueryHandlerFactory) {
            _baseConn = baseConn;
            _queryHandlerFactory = queryHandlerFactory;

            // TODO: extended query support, copy, function call

            _pendingExecution = [];
            _baseConn.connect(this);
        }
        
        public function handleConnected():void {
            dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTED));
        }
        
        public function handleDisconnected():void {
            // TODO: error out on activity after disconnection
            dispatchEvent(new ConnectionEvent(ConnectionEvent.DISCONNECTED));
        }

        public function handleProtocolError(error:ProtocolError):void {
            LOGGER.error("Protocol error: " + error.message);
            dispatchEvent(new ProtocolErrorEvent(ProtocolErrorEvent.PROTOCOL_ERROR, error));
        }

        public function handleCodecError(error:CodecError):void {
            LOGGER.warn("Codec error: " + error.message);
            dispatchEvent(new CodecErrorEvent(CodecErrorEvent.CODEC_ERROR, error));
        }

        public function handleError(fields:Object):void {
            LOGGER.warn("Error:");
            for (var key:String in fields) {
                LOGGER.warn("\t{0}: {1}", key, fields[key]);
            }
            dispatchEvent(new NoticeEvent(NoticeEvent.ERROR, fields));
        }

        public function handleNotice(fields:Object):void {
            LOGGER.info("Notice:");
            for (var key:String in fields) {
                LOGGER.info("\t{0}: {1}", key, fields[key]);
            }
            dispatchEvent(new NoticeEvent(NoticeEvent.NOTICE, fields));
        }

        public function handleNotification(condition:String, notifierPid:int):void {
            dispatchEvent(new NotificationEvent(condition, notifierPid));
        }

        public function handleParameterChange(name:String, newValue:String):void {
            dispatchEvent(new ParameterChangeEvent(name, newValue));
        }

        public function handleRfq():void {
            if (_pendingExecution.length > 0) {
                var nextQuery:Object = _pendingExecution.shift();
                doExecute(nextQuery.sql, nextQuery.token, nextQuery.handler);
            }
        }
        
        public function cancel(token:QueryToken):void {
            var found:Boolean = false;
            if (_currentToken == token) {
                _baseConn.cancel();
                found = true;
            } else {
                // See if a pending query corresponds to this token
                for (var i:int = 0; i < _pendingExecution.length; i++) {
                    var pending:Object = _pendingExecution[i];
                    if (pending.token == token) {
                        _pendingExecution.splice(i, 1);
                        found = true;
                        break;
                    }
                }
            }
            if (!found) {
                throw new ArgumentError("Attempting to cancel unknown query");
            }
        }
        
        private function doExecute(sql:String, token:QueryToken, handler:IResultHandler):void {
            var queryHandler:IQueryHandler = _queryHandlerFactory.createSimpleHandler(handler);
            _currentHandler = queryHandler;
            _currentToken = token;
            _baseConn.executeSimpleQuery(sql, queryHandler);            
        }
        
        public function close():void {
            _baseConn.close();
        }

        public function execute(sql:String, handler:IResultHandler):QueryToken {
            var token:QueryToken = new QueryToken(sql);
            if (_baseConn.rfq) {
                doExecute(sql, token, handler);
            } else {
                _pendingExecution.push({ sql: sql, token: token, handler: handler });
            }
            return token;
        }
    }
}