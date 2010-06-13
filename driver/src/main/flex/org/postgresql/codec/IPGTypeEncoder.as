package org.postgresql.codec {

    import org.postgresql.febe.IFieldInfo;
    import org.postgresql.io.ICDataOutput;

    public interface IPGTypeEncoder {
        /**
         * Encode the given value into the provided byte array. The encoding
         * may be defined by the server parameters.
         */
        function encode(bytes:ICDataOutput, value:Object, fieldInfo:IFieldInfo, serverParams:Object):void;
    }
}