package org.postgresql.codec.encode {

    import org.postgresql.Oid;
    import org.postgresql.io.ICDataOutput;

    public class Int4In extends AbstractIntIn {

        protected override function binaryEncodeInt(bytes:ICDataOutput, value:Object, serverParams:Object):void {
            bytes.writeInt(int(value));
        }

        public override function getInputOid(clazz:Class):int {
            return Oid.INT4;
        }

    }
}