package org.postgresql.event {

    import flash.events.Event;
    /**
     * An Error related to the connection itself, rather than to any
     * queries issued through the connection.
     */
    public class ConnectionErrorEvent extends Event {

        /**
         * The underlying connection to the PostgreSQL backend was lost
         */
        public static const CONNECTIVITY_ERROR:String = 'connectivityError';
        /**
         * An error has occurred in the handling of the underlying protocol.
         */
        public static const PROTOCOL_ERROR:String = 'protocolError';
        /**
         * The underlying connection encountered an error in encoding or
         * decoding data. This is normally due to the lack of a suitable
         * codec, or an error in a codec.
         */
        public static const CODEC_ERROR:String = 'codecError';

        private var _cause:Error;

        /**
         * @private
         */
        public function ConnectionErrorEvent(type:String, cause:Error) {
            super(type);
            _cause = cause;
        }

        /**
         * The Error that triggered this Event.
         */
        public function get cause():Error {
            return _cause;
        }
    }
}