package org.postgresql.febe.event {

    import flash.events.Event;

    public class ConnectionEvent extends Event {

        public static const CONNECTED:String = 'connectedConnectionEvent';
        public static const CLOSED:String = 'closedConnectionEvent';

        public function ConnectionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
            super(type, bubbles, cancelable);
        }

    }
}