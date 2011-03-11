package org.postgresql.codec.encode {
    import org.postgresql.EncodingFormat;
    import org.postgresql.util.AbstractMethodError;
    import org.postgresql.codec.IPGTypeEncoder;
    import org.postgresql.io.ICDataOutput;

    /**
     * @author maciek
     */
    public class AbstractIntIn implements IPGTypeEncoder {
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

        protected /* abstract */ function binaryEncodeInt(bytes:ICDataOutput, value:Object, serverParams:Object):void {
            throw new AbstractMethodError();
        }

        public /* abstract */ function getInputOid(clazz:Class):int {
            throw new AbstractMethodError();
        }
    }
}
