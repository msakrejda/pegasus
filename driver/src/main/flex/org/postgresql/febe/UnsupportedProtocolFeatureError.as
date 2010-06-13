package org.postgresql.febe {

    public class UnsupportedProtocolFeatureError extends Error {
        public function UnsupportedProtocolFeatureError(message:String="", id:int=0) {
            super(message, id);
        }
    }
}