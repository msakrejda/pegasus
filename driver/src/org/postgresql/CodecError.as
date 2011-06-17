package org.postgresql {

    /**
     * Indicates an encoding or decoding error. For communication
     * with the backend, data must be encoded and decoded according
     * to the protocol specification. This error indicates a failure
     * in this process.
     * <br/>
     * This error does <em>not</em> break the connection, but it does
     * indicate that the current query has failed.
     */
    public class CodecError extends Error {

        /**
         * An encoding error.
         */
        public static const ENCODE:String = 'encode';

        /**
         * A decoding error.
         */
        public static const DECODE:String = 'decode';

        private var _direction:String;
        private var _oid:int;
        private var _as3Type:Class;
        private var _cause:Error;

        /**
         * @private
         */
        public function CodecError(message:String, direction:String, cause:Error, oid:int=0 /* Oid.UNSPECIFIED */, as3Type:Class=null) {
            super(message);
            _direction = direction;
            _cause = cause;
            _oid = oid;
            _as3Type = as3Type;
        }

        /**
         * Original <code>Error</code> causing this codec error, if any
         *
         * @return cause, or <code>null</code> if no nested cause
         */
        public function get cause():Error {
            return _cause;
        }

        /**
         * If applicable, the ActionScript <code>Class</code> of the destination type (when
         * decoding) or the source type (when encoding).
         */
        public function get as3Type():Class {
            return _as3Type;
        }

        /**
         * If applicable, the oid of the destination type (when encoding) or
         * the source type (when decoding).
         */
        public function get oid():int {
            return _oid;
        }

        /**
         * Whether the error was encountered in encoding or decoding.
         * @see #ENCODE
         * @see #DECODE
         */
        public function get direction():String {
            return _direction;
        }
    }
}