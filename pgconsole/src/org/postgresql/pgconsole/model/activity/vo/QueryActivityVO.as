package org.postgresql.pgconsole.model.activity.vo {
    import mx.collections.ArrayCollection;

    public class QueryActivityVO extends ConnectionActivityVO {

        private var _sql:String;
        private var _args:Array;
        private var _responses:ArrayCollection;

        public function QueryActivityVO(sql:String, args:Array, responses:Array) {
            _sql = sql;
            _args = args;
            _responses = new ArrayCollection(responses);
        }

        public function get sql():String {
            return _sql;
        }

        public function get args():Array {
            return _args;
        }

        public function get responses():ArrayCollection {
            return _responses;
        }

    }
}
