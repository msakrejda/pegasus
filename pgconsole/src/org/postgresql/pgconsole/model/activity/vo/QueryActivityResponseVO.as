package org.postgresql.pgconsole.model.activity.vo {

    public class QueryActivityResponseVO extends ConnectionActivityVO {

        private var _tag:String;
        private var _rows:int;
        private var _columns:Array;
        private var _data:Array;

        public function QueryActivityResponseVO(tag:String, rows:int, columns:Array=null, data:Array=null) {
            _rows = rows;
            _tag = tag;
            _data = data;
            _columns = columns;
        }

        public function get data():Array {
            return _data;
        }

        public function get columns():Array {
            return _columns;
        }

        public function get tag():String {
            return _tag;
        }

        public function get rows():int {
            return _rows;
        }
    }
}
