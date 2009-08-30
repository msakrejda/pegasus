package org.postgresql.febe.message
{
    import flash.utils.IDataInput;
    
    public interface IBEMessage extends IMessage
    {
        /**
         * Read the message payload. This does not include the
         * one-byte message type header, nor the message length.
         */ 
        function read(input:IDataInput):void;
    }
}