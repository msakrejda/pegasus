package org.postgresql.pgconsole.model.vo {

    public class NotificationVO {

        private var _notifierPid:int;
        private var _condition:String;

        public function NotificationVO(condition:String, notifierPid:int) {
            _notifierPid = notifierPid;
            _condition = condition;
        }

        public function get notifierPid():int {
            return _notifierPid;
        }

        public function get condition():String {
            return _condition;
        }


    }
}
