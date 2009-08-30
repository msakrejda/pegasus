package org.postgresql.febe.message
{
    import flash.utils.IDataInput;
    
    public class NoticeResponse extends AbstractInfoMessage implements IBEMessage
    {
        public function read(input:IDataInput):void
        {
            super.read(input);
        }
        
    }
}