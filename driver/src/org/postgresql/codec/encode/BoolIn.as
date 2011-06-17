package org.postgresql.codec.encode {
    import org.postgresql.Oid;
    import org.postgresql.UnsupportedProtocolFeatureError;
    import org.postgresql.EncodingFormat;
    import org.postgresql.codec.IPGTypeEncoder;
    import org.postgresql.io.ICDataOutput;

    public class BoolIn implements IPGTypeEncoder {
        public function encode(bytes:ICDataOutput, value:Object, format:int, serverParams:Object):void {
            switch (format) {
                case EncodingFormat.TEXT:
                    var boolStr:String = Boolean(value).toString();
                    bytes.writeUTFBytes(boolStr);
                    break;
                case EncodingFormat.BINARY:
                    throw new UnsupportedProtocolFeatureError("Binary format not supported");
                    break;
                default:
                    throw new ArgumentError("Unknown format: " + format);
            }
        }

        public function getInputOid(clazz:Class):int {
            return Oid.BOOL;
        }
    }
}
