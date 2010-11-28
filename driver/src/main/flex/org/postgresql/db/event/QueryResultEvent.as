package org.postgresql.db.event {

    import flash.events.Event;

    public class QueryResultEvent extends Event {

        public static const RESULT:String = 'queryResult';

        private var _columns:Array;
        private var _data:Array;

        public function QueryResultEvent(type:String, columns:Array, data:Array) {
            super(type, false, false);
            _data = data;
            _columns = columns;
        }

        public function get columns():Array {
            return _columns;
        }

        public function get data():Array {
            return _data;
        }
    }
}
