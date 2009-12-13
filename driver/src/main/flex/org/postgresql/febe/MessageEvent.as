package org.postgresql.febe {

    import flash.events.Event;
    
    import org.postgresql.febe.message.IMessage;

    public class MessageEvent extends Event {

        public static const RECEIVED:String = "receivedMessageEvent";
        public static const SENT:String = "sentMessageEvent";

        public var message:IMessage;

        public function MessageEvent(type:String, message:IMessage) {
            super(type, false, false);
            this.message = message;
        }

    }
}