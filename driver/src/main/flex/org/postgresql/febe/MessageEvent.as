package org.postgresql.febe {

    import flash.events.Event;
    
    import org.postgresql.febe.message.IMessage;

    public class MessageEvent extends Event {

        /**
         * Dispatched when a message for which there are no listeners is received.
         * The connection is still assumed to be in a valid state, since FEBE is
         * generally fairly robust.
         */
        public static const DROPPED:String = "messageDropped";
        public static const RECEIVED:String = "messageReceived";
        public static const SENT:String = "messageSent";

        public var message:IMessage;

        public function MessageEvent(type:String, message:IMessage) {
            super(type, false, false);
            this.message = message;
        }

    }
}