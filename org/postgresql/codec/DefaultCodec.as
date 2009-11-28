package org.postgresql.codec {

    import org.postgresql.io.ICDataInput;
    import org.postgresql.io.ICDataOutput;

    public class DefaultCodec implements IPGTypeDecoder, IPGTypeEncoder {

        public function decode(bytes:ICDataInput):Object {
            return bytes.readUTFBytes(bytes.bytesAvailable);
        }

        public function encode(stream:ICDataOutput, value:Object):void {
            if (value != null) {
                stream.writeCString(value.toString());
            }
        }

    }
}