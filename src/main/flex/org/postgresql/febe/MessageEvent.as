package org.postgresql.febe {

    import flash.events.Event;

    import org.postgresql.febe.message.IBEMessage;

    public class MessageEvent extends Event {

        // TODO: this duplicates 'types' laid out in the mesage hierarchy itself,
        // but we need to be able to add listeners to specific event types. Perhaps
        // we can add / dispatch on the String representation of the message class types.
        public static const AUTHENTICATION_OK:String = 'AuthenticationOk';
        public static const ERROR_RESPONSE:String = 'ErrorResponse';
        public static const PARAMETER_STATUS:String = 'ParameterStatus';

        public var message:IBEMessage;

        public function MessageEvent(message:IBEMessage, bubbles:Boolean=false, cancelable:Boolean=false) {
            super(message.type, bubbles, cancelable);
            this.message = message;
        }

    }
}