package org.postgresql.util {

    public class NumberUtil {
        // These are the 32-bit float max and min values. There is no 32-bit
        // floating point type in as3, but these are the corresponding values
        // and they can be useful in interoperating with PostgreSQL, which does
        // have a 32-bit floating point type.
        public static const FLOAT_MAX_VALUE:Number = 3.4028234663852886e+38;
        public static const FLOAT_MIN_VALUE:Number = 1.401298464324817e-45;
        public static const FLOAT_MIN_NORMAL:Number = 1.1754943508222875e-38;
        // A constant to reference the smallest *normalized* double-precision
        // floating point Number (the Flash Player as3 library does not provide this)
        public static const DOUBLE_MIN_NORMAL:Number = 2.2250738585072014e-308;
    }
}
