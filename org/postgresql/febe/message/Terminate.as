package org.postgresql.febe.message
{
    import flash.utils.IDataOutput;

    public class Terminate extends AbstractMessage implements IFEMessage
    {
        public function write(out:IDataOutput):void
        {
            out.writeByte(code('X'));
            out.writeInt(4);
        }
        
    }
}