package org.postgresql.codec.encode {

    import org.postgresql.EncodingFormat;
    import org.postgresql.Oid;
    import org.postgresql.codec.IPGTypeEncoder;
    import org.postgresql.febe.IFieldInfo;
    import org.postgresql.io.ICDataOutput;

    public class IntIn implements IPGTypeEncoder {

        public function encode(bytes:ICDataOutput, serverParams:Object, fieldInfo:IFieldInfo, value:Object):void {
            switch (fieldInfo.format) {
                case EncodingFormat.TEXT:
                    bytes.writeUTFBytes(value.toString());
                case EncodingFormat.BINARY:
                    switch (fieldInfo.typeOid) {
                        case Oid.INT2:
                            bytes.writeShort(int(value));
                        case Oid.INT4:
                            bytes.writeInt(int(value));
                        default:
                            throw new ArgumentError("Unable to encode oid: " + fieldInfo.typeOid);
                    }
                default:
                    throw new ArgumentError("Unknown format: " + fieldInfo.format);
            }

        }

    }
}