package org.postgresql.codec {

    import org.postgresql.febe.message.FieldDescription;
    import org.postgresql.io.ICDataInput;
    import org.postgresql.io.ICDataOutput;

    public class DefaultCodec implements IPGTypeDecoder, IPGTypeEncoder {

        public function decode(bytes:ICDataInput, format:FieldDescription):Object {
            return bytes.readUTFBytes(bytes.bytesAvailable);
        }

        public function encode(stream:ICDataOutput, format:int, value:Object):void {
            if (value != null) {
                stream.writeCString(value.toString());
            }
        }

    }
}