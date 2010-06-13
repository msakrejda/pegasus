package org.postgresql.io {
    import flash.events.Event;

    public class DataStreamEvent extends Event {

        public static const PROGRESS:String = 'progress';
        public static const DISCONNECTED:String = 'disconnected';

        public function DataStreamEvent(type:String) {
            super(type);
        }
        
    }
}