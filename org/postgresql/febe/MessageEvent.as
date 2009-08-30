package org.postgresql.febe
{
    import flash.events.Event;
    
    import org.postgresql.febe.message.IMessage;

    public class MessageEvent extends Event
    {
        public var message:IMessage;

        public function MessageEvent(message:IMessage, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(message.type, bubbles, cancelable);
            this.message = message;
        }
        
    }
}