package org.postgresql.codec.decode {

    import org.postgresql.EncodingFormat;
    import org.postgresql.Oid;
    import org.postgresql.codec.IPGTypeDecoder;
    import org.postgresql.febe.IFieldInfo;
    import org.postgresql.io.ICDataInput;

    public class IntOut implements IPGTypeDecoder {

        public function decode(bytes:ICDataInput, format:IFieldInfo, serverParams:Object):Object {
            switch (format.format) {
                case EncodingFormat.TEXT:
                    return int(bytes.readUTFBytes(bytes.bytesAvailable));
                case EncodingFormat.BINARY:
                    switch (format.typeOid) {
                        case Oid.INT2:
                            return bytes.readShort();
                        case Oid.INT4:
                            return bytes.readInt();
                        default:
                            throw new ArgumentError("Unable to decode oid: " + format.typeOid);
                    }
                default:
                    throw new ArgumentError("Unknown format: " + format.format);
            }
        }

        public function getOutputClass(typeOid:int):Class {
            return int;
        }
    }
}