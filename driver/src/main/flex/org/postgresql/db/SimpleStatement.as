package org.postgresql.db {

    import flash.events.EventDispatcher;

    internal class SimpleStatement extends EventDispatcher implements IStatement {

        private var _conn:Connection;
        private var _queryHandlerFactory:QueryHandlerFactory;
        private var _columns:Array;

        public function SimpleStatement(conn:Connection, queryHandlerFactory:QueryHandlerFactory) {
            _conn = conn;
            _queryHandlerFactory = queryHandlerFactory;
        }

        public function executeQuery(sql:String):IResultSet {
        	var resultSet:ResultSet = new ResultSet(this);
        	var queryHandler:SimpleQueryHandler = _queryHandlerFactory.createSimpleHandler(resultSet);
            _conn.execute(sql, queryHandler);
            return resultSet;
        }

        public function executeUpdate(sql:String):IResult {
        	var result:Result = new Result(this);
        	var queryHandler:SimpleQueryHandler = _queryHandlerFactory.createSimpleHandler(result);
            _conn.execute(sql, queryHandler);
            return result;
        }

        public function cancel():void {
            _conn.cancelStatement(this);
        }

        public function close():void {
            _conn.closeStatement(this);
        }
    }
}