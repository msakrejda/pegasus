package org.postgresql.db {

    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    
    import org.postgresql.event.ConnectionEvent;
    import org.postgresql.event.NoticeEvent;
    import org.postgresql.event.NotificationEvent;
    import org.postgresql.event.ParameterChangeEvent;
    import org.postgresql.febe.FEBEConnection;
    import org.postgresql.febe.IConnectionHandler;
    import org.postgresql.febe.IQueryHandler;
    import org.postgresql.febe.MessageBroker;

    public class Connection extends EventDispatcher implements IConnection, IConnectionHandler {

        private var _baseConn:FEBEConnection;
        private var _queryHandlerFactory:QueryHandlerFactory;

        private var _params:Object;
        private var _broker:MessageBroker;

        private var _pendingExecution:Array;
        private var _currentHandler:IQueryHandler;
        private var _currentToken:QueryToken;
        private var _active:Dictionary;


        public function Connection(baseConn:FEBEConnection, queryHandlerFactory:QueryHandlerFactory) {
            _baseConn = baseConn;
            _queryHandlerFactory = queryHandlerFactory;
            _active = new Dictionary();

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

        public function handleError(fields:Object):void {
            dispatchEvent(new NoticeEvent(NoticeEvent.ERROR, fields));
        }

        public function handleNotice(fields:Object):void {
            dispatchEvent(new NoticeEvent(NoticeEvent.NOTICE, fields));
        }

        public function handleNotification(condition:String, notifierPid:int):void {
            dispatchEvent(new NotificationEvent(condition, notifierPid));
        }

        public function handleParameterChange(name:String, newValue:Object):void {
            dispatchEvent(new ParameterChangeEvent(name, newValue));
        }

        public function handleRfq():void {
            if (_pendingExecution.length > 0) {
                var nextQuery:Object = _pendingExecution.shift();
                doExecute(nextQuery.sql, nextQuery.token, nextQuery.handler);
            }
        }
        
        public function cancelStatement(token:QueryToken):void {
            if (!(token in _active)) {
                throw new ArgumentError("Attempting to cancel unknown query");
            }
            if (_currentToken == token) {
                _baseConn.cancel();
            }
            // Dequeue any pending handlers related to this statement
            for (var i:int = 0; i < _pendingExecution.length; i++) {
                var pending:Object = _pendingExecution[i];
                if (pending.token == token) {
                    _pendingExecution.splice(i, 1);
                }
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
        	_active[token] = true;
            if (_baseConn.rfq) {
				doExecute(sql, token, handler);
            } else {
                _pendingExecution.push({ sql: sql, token: token, handler: handler });
            }
            return token;
        }

    }
}