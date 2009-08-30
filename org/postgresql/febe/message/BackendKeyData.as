package org.postgresql.febe.message
{
    import flash.utils.IDataInput;
    
    public class BackendKeyData extends AbstractMessage implements IBEMessage
    {
        public var pid:int;
        public var key:int;

        public function read(input:IDataInput):void
        {
            pid = input.readInt();
            key = input.readInt();
        }
        
    }
}