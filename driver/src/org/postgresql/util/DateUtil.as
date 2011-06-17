package org.postgresql.util {

    /**
     * Utility functions and useful constants related to dates
     */
    public class DateUtil {
        /**
         * The "ticks" (milliseconds since 1970) corresponding to the largest (i.e., furthest in
         * the future) Date instance representable in ActionScript, as per the ECMAScript spec.
         */
        public static const MAX_DATE_TICKS:Number = 8640000000000000;
        /**
         * The "ticks" (milliseconds since 1970) corresponding to the smallest (i.e., furthest in
         * the past) Date instance representable in ActionScript, as per the ECMAScript spec.
         */
        public static const MIN_DATE_TICKS:Number = -8640000000000000;
    }
}