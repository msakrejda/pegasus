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
                    return bytes.readUTFBytes(bytes.bytesAvailable);
                case EncodingFormat.BINARY:
                    throw new ArgumentError("Unsupported format: " + format.format);
                default:
                    throw new ArgumentError("Unknown format: " + format.format);
            }
        }

        public function getOutputClass(typeOid:int):Class {
            return String;
        }
    }
}