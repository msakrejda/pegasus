package org.postgresql.febe.message
{
    import flash.utils.IDataInput;
    
    public class AuthenticationOk extends AbstractMessage implements IBEMessage
    {
        public function readPayload(input:IDataInput):void
        {
            var authInt:int = input.readInt();
            if (authInt != 0) throw new MessageError("Unexpected message contents", this);
        }
        
    }
}