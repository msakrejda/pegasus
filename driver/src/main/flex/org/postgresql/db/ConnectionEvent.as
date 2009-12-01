package org.postgresql.db {

    import flash.events.Event;

    public class ConnectionEvent extends Event {

        public static const CONNECTED:String = 'ConnectionEventConnected';
        public static const CLOSED:String = 'ConnectionEventClosed';

        public function ConnectionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
            super(type, bubbles, cancelable);
        }

    }
}