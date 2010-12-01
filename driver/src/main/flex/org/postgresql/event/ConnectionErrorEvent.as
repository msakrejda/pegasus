package org.postgresql.event {

    import flash.events.Event;

    public class ConnectionErrorEvent extends Event {

        public static const CONNECTIVITY_ERROR:String = 'connectivityError';
        public static const PROTOCOL_ERROR:String = 'protocolError';
        public static const CODEC_ERROR:String = 'codecError';

        private var _cause:Error;

        public function ConnectionErrorEvent(type:String, cause:Error) {
            super(type);
            _cause = cause;
        }

        public function get cause():Error {
            return _cause;
        }
    }
}