package org.postgresql.event {

    import flash.events.Event;

    public class NotificationEvent extends Event {

        public static const NOTIFICATION:String = 'notificationEvent';

        public var condition:String;
        public var notifierPid:int;

        public function NotificationEvent(condition:String, notifierPid:int) {
            super(NOTIFICATION, false, false);
            this.condition = condition;
            this.notifierPid = notifierPid;
        }

    }
}