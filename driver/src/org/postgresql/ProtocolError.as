package org.postgresql {

    /**
     * Indicates a serious miscommunication between the driver and the PostgreSQL backend.
     * No sensible assumptions can be made about the state of the connection after such
     * an error and the connection is dropped.
     */
    public class ProtocolError extends Error {

        /**
         * @private
         */
        public function ProtocolError(message:String="") {
            super(message);
        }

    }
}