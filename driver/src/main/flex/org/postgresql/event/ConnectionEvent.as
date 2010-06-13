package org.postgresql.event {

    import flash.events.Event;

    public class ConnectionEvent extends Event {

        public static const CONNECTED:String = 'connected';
        public static const DISCONNECTED:String = 'disconnected';
        public static const CLOSED:String = 'closed';

        public function ConnectionEvent(type:String) {
            super(type);
        }

    }
}