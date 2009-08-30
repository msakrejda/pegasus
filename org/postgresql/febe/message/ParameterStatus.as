package org.postgresql.febe.message
{
    import flash.utils.IDataInput;
    
    public class ParameterStatus extends AbstractMessage implements IBEMessage
    {
        public var name:String;
        public var value:String;
        public function read(input:IDataInput):void
        {
            name = readCString(input);
            value = readCString(input);
        }
        
    }
}