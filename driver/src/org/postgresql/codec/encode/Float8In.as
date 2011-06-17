package org.postgresql.codec.encode {
    import org.postgresql.EncodingFormat;
    import org.postgresql.Oid;
    import org.postgresql.codec.IPGTypeEncoder;
    import org.postgresql.io.ICDataOutput;

    public class Float8In implements IPGTypeEncoder {
        public function encode(bytes:ICDataOutput, value:Object, format:int, serverParams:Object):void {
            switch (format) {
                case EncodingFormat.TEXT:
                    var numStr:String = Number(value).toString();
                    bytes.writeUTFBytes(numStr);
                    break;
                case EncodingFormat.BINARY:
                    bytes.writeDouble(Number(value));
                    break;
                default:
                    throw new ArgumentError("Unknown format: " + format);
            }
        }

        public function getInputOid(clazz:Class):int {
            return Oid.FLOAT8;
        }
    }
}
