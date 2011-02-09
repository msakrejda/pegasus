package org.postgresql.codec {

    import org.postgresql.febe.IFieldInfo;
    import org.postgresql.io.ICDataInput;

    /**
     * Decodes PostgreSQL types into corresponding ActionScript objects.
     */
    public interface IPGTypeDecoder {
        /**
         * Decode the given value from the encoded byte array. The encoding
         * may be defined by the field description and server parameters.
         * Note that <code>NULL</code> values will never be passed to the decoder
         * (they always decode to <code>null</code>).
         * <br/>
         * Note that if an error is encountered in decoding or the field cannot
         * be decoded for any other reason, this method should throw an <code>Error</code>
         * (or one of its subtypes). It typically should <em>not</em> be a <code>CodecError</code>;
         * the caller will provide that wrapper as appropriate.
         *
         * @param bytes byte stream encoding a given field
         * @param format metadata for the given field as provided by PostgreSQL
         * @param serverParams the server parameters at the time the value is being decoded
         */
        function decode(bytes:ICDataInput, format:IFieldInfo, serverParams:Object):Object;
        /**
         * Indicate which ActionScript <code>Class</code> will be produced by this decoder
         * for the given PostgreSQL data type.
         *
         * @param typeOid PostgreSQL type to be decoded
         * @return <code>Class</code> as which this <code>oid</code> will be decoded
         */
        function getOutputClass(typeOid:int):Class;
    }
}