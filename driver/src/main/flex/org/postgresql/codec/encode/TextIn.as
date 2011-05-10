package org.postgresql.codec.encode {
    import org.postgresql.Oid;
    import org.postgresql.codec.IPGTypeEncoder;
    import org.postgresql.io.ICDataOutput;

    public class TextIn implements IPGTypeEncoder {
        public function encode(bytes:ICDataOutput, value:Object, format:int, serverParams:Object):void {
        }

        public function getInputOid(clazz:Class):int {
            return Oid.TEXT;
        }
    }
}
