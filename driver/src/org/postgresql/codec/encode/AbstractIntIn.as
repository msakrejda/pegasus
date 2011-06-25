package org.postgresql.codec.encode {
    import org.postgresql.EncodingFormat;
    import org.postgresql.util.AbstractMethodError;
    import org.postgresql.codec.IPGTypeEncoder;
    import org.postgresql.io.ICDataOutput;

    /**
     * Base class for encoding integer types.
     */
    public /* abstract */ class AbstractIntIn implements IPGTypeEncoder {
        /**
         * Base encode method. In <code>TEXT</code> mode, simply writes out the textual representation of
         * the integer. In <code>BINARY</code> mode, calls <code>binaryEncodeInt()</code>.
         *
         * @see #binaryEncodeInt
         */
        public function encode(bytes:ICDataOutput, value:Object, format:int, serverParams:Object):void {
            switch (format) {
                case EncodingFormat.TEXT:
                    bytes.writeUTFBytes(value.toString());
                    break;
                case EncodingFormat.BINARY:
                    binaryEncodeInt(bytes, value, serverParams);
                    break;
                default:
                    throw new ArgumentError("Unknown format: " + format);
            }

        }

        /**
         * Encode the given value, as with <code>encode</code>, but mode is always assumed to
         * be <code>BINARY</code> when this method is called. Must be overridden by subclass.
         */
        protected /* abstract */ function binaryEncodeInt(bytes:ICDataOutput, value:Object, serverParams:Object):void {
            throw new AbstractMethodError();
        }

        /**
         * Return input oid. Must be overridden by subclass.
         */
        public /* abstract */ function getInputOid(clazz:Class):int {
            throw new AbstractMethodError();
        }
    }
}
