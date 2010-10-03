package org.postgresql.event {

    import flash.events.Event;

	/**
	 * Indicates a change to the state of the connection.
	 */
    public class ConnectionEvent extends Event {

		/**
		 * A connection to the backend has been established.
		 *
		 * @eventType connected
		 */
        public static const CONNECTED:String = 'connected';

        /**
         * The current connection to the backend has been lost. At this
         * time, there is no way to determine the cause of the disconnection.
         * This event is not dispatched when the connection is closed by
         * the user through normal means.
         *
         * @eventType disconnected
         */
        public static const DISCONNECTED:String = 'disconnected';

        public function ConnectionEvent(type:String) {
            super(type);
        }

    }
}