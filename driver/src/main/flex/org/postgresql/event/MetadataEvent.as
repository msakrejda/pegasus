package org.postgresql.event {
    import flash.events.Event;

    public class MetadataEvent extends Event {

        public static const METADATA:String = 'METADATA';

        public var columns:Array;

        public function MetadataEvent(type:String, columns:Array) {
            super(type);
            this.columns = columns;
        }
    }
}