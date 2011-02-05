package org.postgresql.codec {

    import org.postgresql.febe.IFieldInfo;
    import org.postgresql.io.ICDataOutput;

    public interface IPGTypeEncoder {
        /**
         * Encode the given value into the provided byte array. The encoding
         * may be defined by the server parameters. Note that <code>null</code>
         * values will never be passed to the decoder (they always encode to
         * <code>NULL</code>).
         */
        function encode(bytes:ICDataOutput, value:Object, fieldInfo:IFieldInfo, serverParams:Object):void;
        /**
         * Indicate the oid of the PostgreSQL type values will be encoded to.
         *
         * @param clazz <code>Class</code> of value to be encoded
         * @return oid the oid of the encoded value
         */
        function getInputOid(clazz:Class):int;
    }
}