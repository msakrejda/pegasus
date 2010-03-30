package org.postgresql.event {

    import flash.events.Event;

    public class ConnectionEvent extends Event {

        public static const CONNECTED:String = 'connectedConnectionEvent';
        public static const CLOSED:String = 'closedConnectionEvent';

        public function ConnectionEvent(type:String) {
            super(type);
        }

    }
}