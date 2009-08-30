package org.postgresql.febe.message
{
    import flash.utils.IDataInput;
    
    public class ErrorResponse extends AbstractInfoMessage implements IBEMessage
    {
        public function read(input:IDataInput):void
        {
            super.read(input);
        }
        
    }
}