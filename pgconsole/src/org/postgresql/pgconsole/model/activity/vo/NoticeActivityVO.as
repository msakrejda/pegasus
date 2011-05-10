package org.postgresql.pgconsole.model.activity.vo {

    public class NoticeActivityVO extends ConnectionActivityVO {
        private var _fields:Object;

        public function NoticeActivityVO(fields:Object) {
            _fields = fields;
        }

        public function get fields():Object {
            return _fields;
        }
    }
}
