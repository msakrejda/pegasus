package org.postgresql.febe.message
{
    import flash.utils.IDataOutput;

    public class Sync extends AbstractMessage implements IFEMessage
    {
        public function write(out:IDataOutput):void
        {
            out.writeByte(code('S'));
            out.writeInt(4);
        }
    }
}