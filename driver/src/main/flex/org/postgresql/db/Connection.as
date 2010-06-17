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

        private var _queryHandlerFactory:QueryHandlerFactory;
        private var _baseConn:FEBEConnection;

        private var _params:Object;
        private var _broker:MessageBroker;

        private var _active:Dictionary;
        private var _pendingExecution:Array;
        private var _currentHandler:IQueryHandler;
        private var _currentStatement:IStatement;

        public function Connection(baseConn:FEBEConnection, queryHandlerFactory:QueryHandlerFactory) {
            _baseConn = baseConn;
            // TODO: this is only passed off to Statements, so it should be pulled up
            // into an injected statementFactory
            _queryHandlerFactory = queryHandlerFactory;

            // TODO: extended query support, copy, function call

            _active = new Dictionary();
            _pendingExecution = [];
            _baseConn.connect(this);
        }
        
        public function handleConnected():void {
            dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTED));
        }
        
        public function handleConnectionDrop():void {
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
                _baseConn.executeSimpleQuery(nextQuery.sql, nextQuery.handler);
            }
        }
        
        internal function cancelStatement(stmt:IStatement):void {
            if (!(stmt in _active)) {
                throw new ArgumentError("Attempting to cancel unregistered statement: " + stmt);
            }
            if (_currentStatement == stmt) {
                _baseConn.cancel();
            }
            // Dequeue any pending handlers related to this statement
            for (var i:int = 0; i < _pendingExecution.length; i++) {
                var pending:Object = _pendingExecution[i];
                if (pending.statement == stmt) {
                    _pendingExecution.splice(i, 1);
                }
            }
        }

        public function createStatement():IStatement {
            var s:IStatement = new SimpleStatement(this, _queryHandlerFactory);
            _active[s] = true;
            return s;
        }
        
        public function close():void {
            _baseConn.close();
        }

        internal function execute(sql:String, statement:IStatement, handler:IQueryHandler):void {
            if (!(statement in _active)) {
                throw new ArgumentError("Attempting to execute unregistered statement: " + statement);
            }

            if (_baseConn.rfq) {
                _currentHandler = handler;
                _currentStatement = statement;
                _baseConn.executeSimpleQuery(sql, handler);
            } else {
                _pendingExecution.push({ sql: sql, statement: statement, handler: handler });
            }
        }

        internal function closeStatement(statement:IStatement):void {
            // TODO: clean up outstanding handlers for statement
            if (!(statement in _active)) {
                throw new ArgumentError("Attempting to close unregistered statement: " + statement);
            }
            // TODO: Send close for portal / statement when not just simple query protocol
            delete _active[statement];
        }


    }
}