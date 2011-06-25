package org.postgresql.codec {

    import org.postgresql.io.ICDataOutput;

    /**
     * Encodes ActionScript objects into corresponding PostgreSQL types.
     */
    public interface IPGTypeEncoder {
        /**
         * Encode the given value into the provided byte array. The encoding
         * may need to take the server parameters into account. Note that <code>null</code>
         * values will never be passed to the encoder (they always encode to
         * <code>NULL</code>).
         * <br/>
         * Note that if an error is encountered in encoding or the field cannot
         * be encoded for any other reason, this method should throw an <code>Error</code>
         * (or one of its subtypes). It typically should <em>not</em> be a <code>CodecError</code>;
         * the caller will provide that wrapper as appropriate.
         * @param bytes the <code>ByteArray</code> to which the encoded value should be written
         * @param value value to encode
         * @param format format in which value should be encoded
         * @param serverParams the current values of the server parameters
         * @see org.postgresql.EncodingFormat
         */
        function encode(bytes:ICDataOutput, value:Object, format:int, serverParams:Object):void;
        /**
         * Indicate the oid of the PostgreSQL type values will be encoded to.
         *
         * @param clazz <code>Class</code> of value to be encoded
         * @return the oid of the encoded value
         */
        function getInputOid(clazz:Class):int;
    }
}