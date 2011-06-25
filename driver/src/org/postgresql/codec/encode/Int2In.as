package org.postgresql.codec.encode {
    import org.postgresql.io.ICDataOutput;
    import org.postgresql.Oid;

    /**
     * Encodes ActionScript <code>int</code>s into PostgreSQL <code>int2</code> values.
     */
    public class Int2In extends AbstractIntIn {

        /**
         * Encodes a 2-byte integer in binary mode.
         */
        protected override function binaryEncodeInt(bytes:ICDataOutput, value:Object, serverParams:Object):void {
            bytes.writeShort(int(value));
        }

        /**
         * This encoder returns <code>Oid.INT2</code>.
         *
         * @see org.postgresql.Oid#INT2
         */
        public override function getInputOid(clazz:Class):int {
            return Oid.INT2;
        }

    }
}
