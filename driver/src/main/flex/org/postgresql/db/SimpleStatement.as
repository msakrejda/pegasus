package org.postgresql.db {

    import flash.events.EventDispatcher;

    internal class SimpleStatement extends EventDispatcher implements IStatement {

        private var _conn:Connection;
        private var _columns:Array;

        public function SimpleStatement(conn:Connection) {
            _conn = conn;
        }
        
        internal function setColumns(value:Array):void {
        	_columns = value;
        }

        public function get columns():Array {
        	return _columns;
        }

        public function execute(sql:String):void {
            _conn.executeQuery(this, sql);
        }

        public function close():void {
            _conn.closeStatement(this);
        }
    }
}