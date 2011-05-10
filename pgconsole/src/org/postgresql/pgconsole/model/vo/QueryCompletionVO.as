package org.postgresql.pgconsole.model.vo {

    public class QueryCompletionVO {

        private var _command:String;
        private var _affectedRows:int;
        private var _columns:Array;
        private var _data:Array;

        public function QueryCompletionVO(command:String, affectedRows:int, columns:Array=null, data:Array=null) {
            _affectedRows = affectedRows;
            _command = command;
            _columns = columns;
            _data = data;
        }

        public function get command():String {
            return _command;
        }

        public function get affectedRows():int {
            return _affectedRows;
        }

        public function get data():Array {
            return _data;
        }

        public function get columns():Array {
            return _columns;
        }

    }
}
