package org.postgresql.pgconsole.model.vo {

    public class QueryVO {
        private var _sql:String;
        private var _args:Array;

        public function QueryVO(sql:String, args:Array) {
            _sql = sql;
            _args = args;
        }

        public function get sql():String {
            return _sql;
        }

        public function get args():Array {
            return _args;
        }

        public function toString():String {
            return 'sql: {' + _sql + '} args {' + (args ? args.join(', ') : '') + '}';
        }
    }
}
