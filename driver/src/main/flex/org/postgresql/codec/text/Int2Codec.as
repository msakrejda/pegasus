package org.postgresql.codec {

	import org.postgresql.febe.message.FieldDescription;
	import org.postgresql.io.ICDataInput;
	import org.postgresql.io.ICDataOutput;

	public class Int2Codec implements IPGTypeDecoder, IPGTypeEncoder {

		public function decode(bytes:ICDataInput, format:FieldDescription, serverParams:Object):Object {
			return int(bytes.readUTFBytes(bytes.bytesAvailable));
		}
		
		public function encode(bytes:ICDataOutput, serverParams:Object, value:Object):void {
			bytes.writeUTFBytes(value.toString());
		}
		
	}
}