package org.postgresql.codec.decode {

	import org.postgresql.codec.IPGTypeDecoder;
	import org.postgresql.EncodingFormat;
	import org.postgresql.febe.FieldDescription;
	import org.postgresql.Oid;
	import org.postgresql.io.ICDataInput;

	public class IntOut implements IPGTypeDecoder {

		public function decode(bytes:ICDataInput, format:FieldDescription, serverParams:Object):Object {
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

	}
}