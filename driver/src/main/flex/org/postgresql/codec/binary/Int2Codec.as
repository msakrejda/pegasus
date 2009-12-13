package org.postgresql.codec.binary {

	import org.postgresql.febe.message.FieldDescription;
	import org.postgresql.io.ICDataInput;
	import org.postgresql.io.ICDataOutput;

	public class Int2Codec implements IPGTypeDecoder, IPGTypeEncoder {

		public function decode(bytes:ICDataInput, format:FieldDescription, serverParams:Object):Object {
			return bytes.readShort();
		}

		public function encode(bytes:ICDataOutput, serverParams:Object, value:Object):void {
			bytes.writeShort(value);
		}

	}
}