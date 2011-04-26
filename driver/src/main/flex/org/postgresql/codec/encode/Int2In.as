package org.postgresql.codec.encode {
    import org.postgresql.io.ICDataOutput;
    import org.postgresql.Oid;

    public class Int2In extends AbstractIntIn {
        protected override function binaryEncodeInt(bytes:ICDataOutput, value:Object, serverParams:Object):void {
            bytes.writeShort(int(value));
        }

        public override function getInputOid(clazz:Class):int {
            return Oid.INT2;
        }

    }
}
