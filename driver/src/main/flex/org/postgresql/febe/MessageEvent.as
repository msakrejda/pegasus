package org.postgresql.febe {

    import flash.events.Event;
    
    import org.postgresql.febe.message.IMessage;

    public class MessageEvent extends Event {

        public static const RECEIVED:String = "messageReceived";
        public static const SENT:String = "messageSent";

        public var message:IMessage;

        public function MessageEvent(type:String, message:IMessage) {
            super(type, false, false);
            this.message = message;
        }

    }
}