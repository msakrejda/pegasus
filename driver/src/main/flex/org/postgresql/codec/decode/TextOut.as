package org.postgresql.codec.decode {

    import org.postgresql.EncodingFormat;
    import org.postgresql.Oid;
    import org.postgresql.codec.IPGTypeDecoder;
    import org.postgresql.febe.IFieldInfo;
    import org.postgresql.io.ICDataInput;

    public class TextOut implements IPGTypeDecoder {

        public function decode(bytes:ICDataInput, format:IFieldInfo, serverParams:Object):Object {
            switch (format.format) {
                case EncodingFormat.TEXT:
                    switch (format.typeOid) {
                        // TODO: we make the assumption that the driver won't send data
                        // that doesn't match the type attributes
                        case Oid.BPCHAR:
                        case Oid.VARCHAR:
                        case Oid.TEXT:
                        case Oid.CHAR:
                            return bytes.readUTFBytes(bytes.bytesAvailable);
                        default:
                            throw new ArgumentError("Unable to decode oid: " + format.typeOid);
                    }
                case EncodingFormat.BINARY:
                    throw new ArgumentError("Unsupported format: " + format.format);
                default:
                    throw new ArgumentError("Unknown format: " + format.format);
            }
        }
    }
}