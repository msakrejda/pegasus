package org.postgresql {

    /**
     * This error indicates a serious miscommunication between the
     * driver and the PostgreSQL backend. There is no sense in
     * trying to recover, so the connection is dropped.
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