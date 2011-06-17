package org.postgresql {

    /**
     * Indicates a ProtocolError caused by unimplemented
     * functionality in the driver.
     */
    public class UnsupportedProtocolFeatureError extends ProtocolError {

        /**
         * @private
         */
        public function UnsupportedProtocolFeatureError(message:String="") {
            super(message);
        }

    }
}