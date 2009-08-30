package org.postgresql.febe
{
    import flash.events.Event;
    
    import org.postgresql.febe.message.IMessage;

    public class MessageEvent extends Event
    {
        public var message:IMessage;

        public function MessageEvent(type:String, msg:IMessage, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
            message = msg;
        }
        
    }
}