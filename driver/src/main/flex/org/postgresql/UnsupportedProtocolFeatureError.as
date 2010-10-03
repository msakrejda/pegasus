package org.postgresql {

    public class UnsupportedProtocolFeatureError extends ProtocolError {

        public function UnsupportedProtocolFeatureError(message:String="", id:int=0) {
            super(message, id);
        }

    }
}