package org.postgresql.pgconsole.model.vo {

    public class NoticeVO {
        private var _fields:Object;

        public function NoticeVO(fields:Object) {
            _fields = fields;
        }
        public function get fields():Object {
            return _fields;
        }

    }
}
