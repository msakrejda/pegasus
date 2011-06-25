package org.postgresql.codec.decode {
    import org.postgresql.Oid;
    import org.postgresql.EncodingFormat;
    import org.postgresql.codec.IPGTypeDecoder;
    import org.postgresql.febe.IFieldInfo;
    import org.postgresql.io.ICDataInput;

    /**
     * Parse a PostgreSQL <code>bool</code> into an ActionScript <code>Boolean</code>.
     */
    public class BoolOut implements IPGTypeDecoder {
        /**
         * @inheritDoc
         */
        public function decode(bytes:ICDataInput, format:IFieldInfo, serverParams:Object):Object {
            switch (format.format) {
                case EncodingFormat.TEXT:
                    return Boolean(bytes.readUTFBytes(bytes.bytesAvailable));
                case EncodingFormat.BINARY:
                    switch (format.typeOid) {
                        case Oid.BOOL:
                            return bytes.readBoolean();
                        default:
                            throw new ArgumentError("Unable to decode oid: " + format.typeOid);
                    }
                default:
                    throw new ArgumentError("Unknown format: " + format.format);
            }
        }

        /**
         * This decoder returns <code>Boolean</code>.
         * @see Boolean
         */
        public function getOutputClass(typeOid:int):Class {
            return Boolean;
        }
    }
}
