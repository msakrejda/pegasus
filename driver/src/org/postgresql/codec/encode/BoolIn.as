package org.postgresql.codec.encode {
    import org.postgresql.Oid;
    import org.postgresql.UnsupportedProtocolFeatureError;
    import org.postgresql.EncodingFormat;
    import org.postgresql.codec.IPGTypeEncoder;
    import org.postgresql.io.ICDataOutput;

    /**
     * Encodes ActionScript <code>Boolean</code>s into PostgreSQL <code>bool</code> values.
     */
    public class BoolIn implements IPGTypeEncoder {

        /**
         * @inheritDoc
         */
        public function encode(bytes:ICDataOutput, value:Object, format:int, serverParams:Object):void {
            switch (format) {
                case EncodingFormat.TEXT:
                    var boolStr:String = Boolean(value) ? 't' : 'f';
                    bytes.writeUTFBytes(boolStr);
                    break;
                case EncodingFormat.BINARY:
                    throw new UnsupportedProtocolFeatureError("Binary format not supported");
                    break;
                default:
                    throw new ArgumentError("Unknown format: " + format);
            }
        }

        /**
         * This encoder returns <code>Oid.BOOL</code>.
         *
         * @see org.postgresql.Oid#BOOL
         */
        public function getInputOid(clazz:Class):int {
            return Oid.BOOL;
        }
    }
}
