package org.postgresql.db.event {

    import flash.events.Event;

    public class QueryCompletionEvent extends Event {
        
        public static const COMPLETE:String = 'queryComplete';

        private var _tag:String;        
        private var _rows:int;
        private var _oid:int;

        public function QueryCompletionEvent(type:String, tag:String, rows:int, oid:int) {
            super(type, false, false);
            _tag = tag;
            _rows = rows;
            _oid = oid;
        }

        public function get rows():int {
            return _rows;
        }

        public function get oid():int {
            return _oid;
        }

        public function get tag():String {
            return _tag;
        }
    }
}
