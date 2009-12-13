package org.postgresql.codec {

    import org.postgresql.febe.FieldDescription;
    import org.postgresql.io.ICDataInput;
    import org.postgresql.io.ICDataOutput;

    public class DefaultCodec implements IPGTypeDecoder, IPGTypeEncoder {

        public function decode(bytes:ICDataInput, format:FieldDescription, serverParams:Object):Object {
            return bytes.readUTFBytes(bytes.bytesAvailable);
        }

        public function encode(bytes:ICDataOutput, serverParams:Object, value:Object):void {
            bytes.writeUTFBytes(value.toString());
        }

    }
}