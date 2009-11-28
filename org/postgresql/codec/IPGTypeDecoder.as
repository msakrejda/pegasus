package org.postgresql.codec {

    import flash.utils.IDataInput;

    public interface IPGTypeDecoder {
        function decode(bytes:IDataInput):Object;
    }
}