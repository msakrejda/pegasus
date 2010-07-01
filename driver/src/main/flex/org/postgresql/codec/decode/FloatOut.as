package org.postgresql.codec.decode {

    import org.postgresql.EncodingFormat;
    import org.postgresql.Oid;
    import org.postgresql.codec.IPGTypeDecoder;
    import org.postgresql.febe.IFieldInfo;
    import org.postgresql.io.ICDataInput;

    public class FloatOut implements IPGTypeDecoder {

        public function decode(bytes:ICDataInput, format:IFieldInfo, serverParams:Object):Object {
            switch (format.format) {
                case EncodingFormat.TEXT:
                	// Note that this also parses 'Infinity', '-Infinity', and 'NaN'
                    return Number(bytes.readUTFBytes(bytes.bytesAvailable));
                case EncodingFormat.BINARY:
                    switch (format.typeOid) {
                        // N.B.: We could theoretically support numerics that are expressible
                        // as floats, but that's probably not worth it right now
                        case Oid.FLOAT4:
                            return bytes.readFloat();
                        case Oid.INT4:
                            return bytes.readDouble();
                        default:
                            throw new ArgumentError("Unable to decode oid: " + format.typeOid);  
                    }
                default:
                    throw new ArgumentError("Unknown format: " + format.format);
            }
        }
        
    }
}