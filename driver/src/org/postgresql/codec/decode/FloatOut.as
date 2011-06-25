package org.postgresql.codec.decode {

    import org.postgresql.EncodingFormat;
    import org.postgresql.Oid;
    import org.postgresql.codec.IPGTypeDecoder;
    import org.postgresql.febe.IFieldInfo;
    import org.postgresql.io.ICDataInput;

    /**
     * Parse a PostgreSQL <code>double precision</code> or <code>float</code> value into
     * an ActionScript <code>Number</code>. Since both support IEEE floating point numbers,
     * the mapping is fairly straightforward, albeit it depends on the <code>extra_float_digits</code>
     * PostgreSQL setting.
     */
    public class FloatOut implements IPGTypeDecoder {

        // This is an interesting tidbit of IEEE fun... Due to the default precision PostgreSQL
        // uses when printing doubles in text mode, the textual representation of the largest double
        // is a value rounded to something *bigger* than the largest double (and, correspondingly, Number).
        // Hilarity ensues. This is the sober workaround to that rampant hilarity. A better solution
        // would be to work with extra_float_digits, but it's a little ugly to force that. Perhaps we
        // can set it but fall back if it's subsequently changed.
        private static const MAX_PG_DOUBLE_STR:String = "1.79769313486232e+308";

        /**
         * @inheritDoc
         */
        public function decode(bytes:ICDataInput, format:IFieldInfo, serverParams:Object):Object {
            switch (format.format) {
                case EncodingFormat.TEXT:
                    // Note that this also parses 'Infinity', '-Infinity', and 'NaN'
                    var resultStr:String = bytes.readUTFBytes(bytes.bytesAvailable);
                    var result:Number = Number(resultStr);
                    // As noted above, PostgreSQL formats the largest double into something that the
                    // Number() function treats as Infinity. So if it's not finite, not NaN (because
                    // NaN is considered "not finite"), and matches the string above, we treat it as
                    // Number.MAX_VALUE (modulo sign); otherwise, we just return what Number() gave.
                    // Unfortunately, this approach only works for the default extra_float_digits setting.
                    if (!isFinite(result) && !isNaN(result) && resultStr.indexOf(MAX_PG_DOUBLE_STR) != -1) {
                        return result > 0 ? Number.MAX_VALUE : -Number.MAX_VALUE;
                    } else {
                        return result;
                    }
                case EncodingFormat.BINARY:
                    switch (format.typeOid) {
                        // N.B.: We could theoretically support numerics that are expressible
                        // as floats, but that's probably not worth it right now
                        case Oid.FLOAT4:
                            return bytes.readFloat();
                        case Oid.FLOAT8:
                            return bytes.readDouble();
                        default:
                            throw new ArgumentError("Unable to decode oid: " + format.typeOid);
                    }
                default:
                    throw new ArgumentError("Unknown format: " + format.format);
            }
        }

        /**
         * This decoder returns <code>Number</code>.
         * @see Number
         */
        public function getOutputClass(typeOid:int):Class {
            return Number;
        }

    }
}