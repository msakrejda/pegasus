package org.postgresql.util {

    /**
     * Utility functions and useful constants related to floating point numbers
     */
    public class NumberUtil {
        /**
         * The largest value representable in an IEEE-754 32-bit floating point number.
         */
        public static const FLOAT_MAX_VALUE:Number = 3.4028234663852886e+38;
        /**
         * The smallest value representable in a denormalized IEEE-754 32-bit floating point number.
         */
        public static const FLOAT_MIN_VALUE:Number = 1.401298464324817e-45;
        /**
         * The smallest value representable in a normalized IEEE 32-bit floating point number.
         */
        public static const FLOAT_MIN_NORMAL:Number = 1.1754943508222875e-38;
        /**
         * The smallest value representable in a normalized IEEE 64-bit floating point number.
         */
        public static const DOUBLE_MIN_NORMAL:Number = 2.2250738585072014e-308;
    }
}
