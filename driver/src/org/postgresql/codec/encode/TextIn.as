package org.postgresql.codec.encode {
    import org.postgresql.UnsupportedProtocolFeatureError;
    import org.postgresql.EncodingFormat;
    import org.postgresql.Oid;
    import org.postgresql.codec.IPGTypeEncoder;
    import org.postgresql.io.ICDataOutput;

    /**
     * Encodes ActionScript <code>String</code>s into PostgreSQL <code>text</code> values.
     */
    public class TextIn implements IPGTypeEncoder {

        /**
         * @inheritDoc
         */
        public function encode(bytes:ICDataOutput, value:Object, format:int, serverParams:Object):void {
            switch (format) {
                case EncodingFormat.TEXT:
                    bytes.writeUTFBytes(String(value));
                    break;
                case EncodingFormat.BINARY:
                    throw new UnsupportedProtocolFeatureError("Binary format not supported");
                    break;
                default:
                    throw new ArgumentError("Unknown format: " + format);
            }
        }

        /**
         * This encoder returns <code>Oid.TEXT</code>.
         *
         * @see org.postgresql.Oid#TEXT
         */
        public function getInputOid(clazz:Class):int {
            return Oid.TEXT;
        }
    }
}
