package org.postgresql.event {

    import flash.events.Event;

    /**
     * Indicates a notice or error sent by the server.
     */
    public class NoticeEvent extends Event {

        /**
         * A notice (informational) message from PostgreSQL.
         *
         * @eventType notice
         */
        public static const NOTICE:String = 'notice';

        /**
         * An error message from PostgreSQL.
         *
         * @eventType error
         */
        public static const ERROR:String = 'error';

        private var _fields:Object;

        /**
         * Details of the message, as a map of notice field code to corresponding message.
         *
         * @see org.postgresql.NoticeFields
         */
        public function get fields():Object {
            return _fields;
        }

        /**
         * Create a new notice event.
         *
         * @param type type of notice
         * @param fields fields describing notice
         *
         * @private
         */
        public function NoticeEvent(type:String, fields:Object) {
            super(type);
            _fields = fields;
        }

    }
}