package org.postgresql.db {

    import flash.events.EventDispatcher;

    internal class SimpleStatement extends EventDispatcher implements IStatement {

        private var _conn:Connection;
        private var _columns:Array;

        public function SimpleStatement(conn:Connection) {
            _conn = conn;
        }

        public function get columns():Array {
        	return _columns;
        }

        public function executeQuery(sql:String):ResultSet {
            _conn.executeQuery(this, sql);
            return null;
        }

        public function executeUpdate(sql:String):Result {
            return null;
        }

        public function cancel():void {
            _conn.cancelStatement(this);
        }

        public function close():void {
            _conn.closeStatement(this);
        }
    }
}