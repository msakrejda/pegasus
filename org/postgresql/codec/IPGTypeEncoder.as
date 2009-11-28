package org.postgresql.codec {

    import flash.utils.IDataOutput;

    public interface IPGTypeEncoder {
        function encode(stream:IDataOutput):void;
    }
}