package org.postgresql.db {

    import flash.events.EventDispatcher;

    internal class SimpleStatement extends EventDispatcher implements IStatement {

        private var _conn:Connection;

        public function SimpleStatement(conn:Connection) {
            _conn = conn;
        }

        public function get columns():Array {
        	return [];
        }

        public function execute(sql:String):void {
            _conn.executeQuery(this, sql);
        }

        public function close():void {
            _conn.closeStatement(this);
        }
    }
}