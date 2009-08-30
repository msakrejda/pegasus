package org.postgresql.febe.message
{
    import flash.utils.IDataOutput;
    
    public interface IFEMessage extends IMessage
    {
        function write(out:IDataOutput):void;
    }
}