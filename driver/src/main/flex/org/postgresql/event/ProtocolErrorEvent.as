package org.postgresql.event {

    import flash.events.ErrorEvent;
    
    import org.postgresql.ProtocolError;
    
    /**
     * Indicates that a protocol error has occurred asynchronously. Note that
     * protocol errors are considered fatal and the associated connection will
     * be closed.
     */
    public class ProtocolErrorEvent extends ErrorEvent {

        /**
         * A protocol error. The attached error contains more details.
         *
         * @eventType protocolError
         */
        public static const PROTOCOL_ERROR:String = 'protocolError';

        /**
         * The error that occurred.
         */
        public var error:ProtocolError;

        public function ProtocolErrorEvent(type:String, error:ProtocolError) {
            super(type, false, false, text);
            this.error = error;
        }
        
    }
}