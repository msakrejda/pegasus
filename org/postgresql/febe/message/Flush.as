package org.postgresql.febe.message
{
    import flash.utils.IDataOutput;

    public class Flush extends AbstractMessage implements IFEMessage
    {
        public function write(out:IDataOutput):void
        {
            out.writeByte(code('H'));
            out.writeInt(4);
        }
        
    }
}