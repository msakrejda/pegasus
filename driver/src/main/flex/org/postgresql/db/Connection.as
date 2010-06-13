package org.postgresql.db {

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    
    import org.postgresql.event.NoticeEvent;
    import org.postgresql.event.NotificationEvent;
    import org.postgresql.febe.FEBEConnection;
    import org.postgresql.febe.IQueryHandler;
    import org.postgresql.febe.MessageBroker;

    public class Connection extends EventDispatcher {

        private var _queryHandlerFactory:QueryHandlerFactory;
        private var _baseConn:FEBEConnection;

        private var _params:Object;
        private var _broker:MessageBroker;

        private var _active:Dictionary;
        private var _pendingExecution:Array;
        private var _currentlyExecuting:IQueryHandler;

        // query handler factory instead of CodecFactory--codecs are only used for handlers
        
        public function Connection(baseConn:FEBEConnection, queryHandlerFactory:QueryHandlerFactory) {
            _baseConn = baseConn;
            _queryHandlerFactory = queryHandlerFactory;

            // add listeners to the baseConn for rfq, paramStatus, notice / error / notification
            _baseConn.addEventListener(FEBEConnection.READY_FOR_QUERY, handleRfq);

            // Unfortunately, our two-tiered approach here means there are a number of
            // events the base connection dispatches that we just want to rebroadcast
            // directly--we do this by cloning them...            
            _baseConn.addEventListener(FEBEConnection.PARAM_CHANGE, handleRebroadcast);
            _baseConn.addEventListener(FEBEConnection.CONNECTED, handleRebroadcast);
            _baseConn.addEventListener(NoticeEvent.NOTICE, handleRebroadcast);
            _baseConn.addEventListener(NoticeEvent.ERROR, handleRebroadcast);
            _baseConn.addEventListener(NotificationEvent.NOTIFICATION, handleRebroadcast);
            
            // support, {simple,extended}QueryExecutor, copy, function call, cancel, terminate

            _active = new Dictionary();
            _pendingExecution = [];
        }

        private function handleRebroadcast(e:Event):void {
        	var newEvent:Event = e.clone();
        	dispatchEvent(newEvent);
        }


        private function handleRfq(e:Event):void {
        	if (_pendingExecution.length > 0) {
        		var nextQuery:Object = _pendingExecution.shift();
        		_baseConn.executeSimpleQuery(nextQuery.sql, nextQuery.handler);
        	}
        }
        
        internal function cancelStatement(stmt:IStatement):void {
            if (!(stmt in _active)) {
                throw new ArgumentError("Attempting to cancel unregistered statement: " + stmt);
            }
            if (_currentlyExecuting.statement == stmt) {
            	_baseConn.cancel();
            }
            // Dequeue any pending handlers related to this statement
        	for (var i:int = 0; i < _pendingExecution.length; i++) {
        		var pending:Object = _pendingExecution[i];
        		if (pending.handler.statement == stmt) {
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

        internal function executeQuery(sql:String, handler:IQueryHandler):void {
            if (!(handler.statement in _active)) {
                throw new ArgumentError("Attempting to execute unregistered statement: " + handler.statement);
            }

            if (_baseConn.rfq) {
            	_currentlyExecuting = handler;
                _baseConn.executeSimpleQuery(sql, handler);
            } else {
                _pendingExecution.push({ handler: handler, sql: sql });
            }
        }

        internal function closeStatement(statement:IStatement):void {
        	// TODO: handle outstanding handlers for statement
            if (!(statement in _active)) {
                throw new ArgumentError("Attempting to close unregistered statement: " + statement);
            }
            // TODO: Send close for portal / statement when not just simple query protocol
            delete _active[statement];
        }


    }
}