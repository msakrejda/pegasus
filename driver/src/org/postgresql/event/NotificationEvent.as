package org.postgresql.event {

    import flash.events.Event;

    /**
     * A notification sent by the server as part of PostgreSQL's LISTEN / NOTIFY
     * functionality.
     */
    public class NotificationEvent extends Event {

        /**
         * A notification through the PostgreSQL LISTEN / NOTIFY protocol.
         *
         * @eventType notification
         */
        public static const NOTIFICATION:String = 'notification';

        private var _notifierPid:int;
        private var _condition:String;

        /**
         * The LISTEN condition.
         */
        public function get condition():String {
            return _condition;
        }

        /**
         * The processs identifier of the notifying process
         */
        public function get notifierPid():int {
            return _notifierPid;
        }

        /**
         * Create a new notification event
         *
         * @param condition condition corresponding to this notification
         * @param notifierPid pid of notifying process
         *
         * @private
         */
        public function NotificationEvent(condition:String, notifierPid:int) {
            super(NOTIFICATION, false, false);
            _condition = condition;
            _notifierPid = notifierPid;
        }

    }
}