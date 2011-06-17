package org.postgresql {

    /**
     * Indicates that the throwing object is not in the required state
     * to perform the requested operation.
     */
    public class InvalidStateError extends Error {
        /**
         * @private
         */
        public function InvalidStateError(message:String) {
            super(message);
        }
    }
}