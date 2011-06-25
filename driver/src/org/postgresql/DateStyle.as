package org.postgresql {

    /**
     * Functionality defining the representation of dates in PostgreSQL.
     */
    public class DateStyle {
        /**
         * Expect dates in ISO-8601 format, e.g., <code>2011-02-01 18:53:12.848059-08</code>.
         */
        public static const OUTPUT_ISO:String = 'ISO';
        /**
         * Expect dates in a legacy format, e.g., <code>Tue 01 Feb 18:54:14.348079 2011 PST</code>.
         * Note that this output format is also affected by the MDY part of the <code>DateStyle</code>
         * setting: when set to <code>DMY</code>, the day is printed first.
         */
        public static const OUTPUT_POSTGRES:String = 'Postgres';
        /**
         * Expect dates in SQL standard format, e.g., <code>01/02/2011 18:56:05.379808 PST</code>.
         * Note that this output format is also affected by the MDY part of the <code>DateStyle</code>
         * setting: when set to <code>DMY</code>, the day is printed first.
         */
        public static const OUTPUT_SQL:String = 'SQL';
        /**
         * Expect dates in a custom legacy format, e.g., <code>01.02.2011 18:55:23.025107 PST</code>.
         */
        public static const OUTPUT_GERMAN:String = 'German';

        /**
         * Parse timestamp literals in the order month, day, year. E.g.,
         * <code>SELECT '10/11/12'::timestamp</code> will produce October 11th, 2012.
         */
        public static const ORDER_MDY:String = 'MDY';
        /**
         * Parse timestamp literals in the order day, month, year. E.g.,
         * <code>SELECT '10/11/12'::timestamp</code> will produce November 10th, 2012.
         */
        public static const ORDER_DMY:String = 'DMY';
        /**
         * Parse timestamp literals in the order day, month, year. E.g.,
         * <code>SELECT '10/11/12'::timestamp</code> will produce November 12th, 2010.
         */
        public static const ORDER_YMD:String = 'YMD';

        /**
         * Get the current setting for parsing day/month/year timestamp literals
         * from a <code>DateStyle</code> value. The possible values are denoted by
         * the constants in this class.
         *
         * @param value a <code>DateStyle</code> string returned by the server
         * @return the specified day/month/year order
         * @see #ORDER_MDY
         * @see #ORDER_DMY
         * @see #ORDER_YMD
         */
        public static function getDMYOrder(value:String):String {
            return parse(value)[1];
        }

        /**
         * Get the current setting for date output format from a <code>DateStyle</code>
         * value. The possible values are denoted by the constants in this class.
         *
         * @param value a <code>DateStyle</code> string returned by the server
         * @return the specified output format style
         * @see #OUTPUT_ISO
         * @see #OUTPUT_POSTGRES
         * @see #OUTPUT_SQL
         * @see #OUTPUT_GERMAN
         */
        public static function getOutputFormat(value:String):String {
            return parse(value)[0];
        }

        /**
         * @private
         */
        private static function parse(value:String):Array {
            var result:Array = value.split(', ');
            if (result.length != 2) {
                throw new ArgumentError("Invalid DateStyle string: " + value);
            } else {
                return result;
            }
        }
    }
}