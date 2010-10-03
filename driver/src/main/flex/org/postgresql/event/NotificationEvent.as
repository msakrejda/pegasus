package org.postgresql.event {

    import flash.events.Event;

	/**
	 * A notification sent by the server as part of PostgreSQL's LISTEN / NOTIFY
	 * functionality.
	 */
    public class NotificationEvent extends Event {

		/**
		 * A notification.
		 *
		 * @eventType notification
		 */
        public static const NOTIFICATION:String = 'notification';

		/**
		 * The LISTEN condition.
		 */
        public var condition:String;

        /**
         * The processs identifier of the notifying process
         */
        public var notifierPid:int;

        public function NotificationEvent(condition:String, notifierPid:int) {
            super(NOTIFICATION, false, false);
            this.condition = condition;
            this.notifierPid = notifierPid;
        }

    }
}