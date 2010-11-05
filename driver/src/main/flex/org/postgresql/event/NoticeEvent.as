package org.postgresql.event {

    import flash.events.Event;

    /**
     * Indicates a notice or error sent by the server. All notices and errors directly
     * relating to a currently-executing query are handled elsewhere, however.
     */
    public class NoticeEvent extends Event {

        /**
         * A notice (informational) message.
         */
        public static const NOTICE:String = 'notice';
        /**
         * An error message.
         */
        public static const ERROR:String = 'error';
        
        /**
         * Details of the message.
         * @see org.postgresql.NoticeFields
         */
        public var fields:Object;

        public function NoticeEvent(type:String, fields:Object) {
            super(type);
            this.fields = fields;
        }

    }
}