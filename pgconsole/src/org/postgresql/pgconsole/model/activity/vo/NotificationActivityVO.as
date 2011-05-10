package org.postgresql.pgconsole.model.activity.vo {

    public class NotificationActivityVO extends ConnectionActivityVO {

        private var _notifierPid:int;
        private var _condition:String;

        public function NotificationActivityVO(condition:String, pid:int) {
            _condition = condition;
            _notifierPid = pid;
        }

        public function get condition():String {
            return _condition;
        }

        public function get notifierPid():int {
            return _notifierPid;
        }
    }
}
