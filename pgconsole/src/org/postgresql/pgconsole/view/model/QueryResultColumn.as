package org.postgresql.pgconsole.view.model {

    public class QueryResultColumn {
        private var _label:String;
        private var _width:Number;

        public function QueryResultColumn(label:String, width:Number) {
            _label = label;
            _width = width;
        }

        public function get label():String {
            return _label;
        }

        public function get width():Number {
            return _width;
        }
    }
}
