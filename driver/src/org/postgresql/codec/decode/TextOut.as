package org.postgresql.codec.decode {

    import org.postgresql.EncodingFormat;
    import org.postgresql.codec.IPGTypeDecoder;
    import org.postgresql.febe.IFieldInfo;
    import org.postgresql.io.ICDataInput;

    /**
     * Parse the text representation of a PostgreSQL type into an ActionScript <code>String</code>;
     * used to decode <code>text</code> or <code>varchar</code> types.
     */
    public class TextOut implements IPGTypeDecoder {

        /**
         * @inheritDoc
         */
        public function decode(bytes:ICDataInput, format:IFieldInfo, serverParams:Object):Object {
            switch (format.format) {
                case EncodingFormat.TEXT:
                    return bytes.readUTFBytes(bytes.bytesAvailable);
                case EncodingFormat.BINARY:
                    throw new ArgumentError("Unsupported format: " + format.format);
                default:
                    throw new ArgumentError("Unknown format: " + format.format);
            }
        }

        /**
         * This decoder returns <code>String</code>.
         *
         * @see String
         */
        public function getOutputClass(typeOid:int):Class {
            return String;
        }
    }
}