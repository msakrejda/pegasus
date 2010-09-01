package org.postgresql.event {

    import flash.events.Event;

    public class ResultSetEvent extends Event {

        public static const RESULT:String = 'result';
        
        public var data:Array;

        public function ResultSetEvent(type:String, data:Array) {
            super(type);
            this.data = data;
        }
        
    }
}