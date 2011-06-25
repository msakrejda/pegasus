package org.postgresql.codec.encode {

    import org.postgresql.Oid;
    import org.postgresql.io.ICDataOutput;

    /**
     * Encodes ActionScript <code>int</code>s into PostgreSQL <code>int4</code> values.
     */
    public class Int4In extends AbstractIntIn {

        /**
         * Encodes a 2-byte integer in binary mode.
         */
        protected override function binaryEncodeInt(bytes:ICDataOutput, value:Object, serverParams:Object):void {
            bytes.writeInt(int(value));
        }

        /**
         * This encoder returns <code>Oid.INT4</code>.
         *
         * @see org.postgresql.Oid#INT4
         */
        public override function getInputOid(clazz:Class):int {
            return Oid.INT4;
        }

    }
}