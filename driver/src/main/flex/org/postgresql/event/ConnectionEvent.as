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

        public function ConnectionEvent(type:String) {
            super(type);
        }

    }
}