package org.postgresql {

    public class ProtocolError extends Error {

        public function ProtocolError(message:String="", id:int=0) {
            super(message, id);
        }

    }
}