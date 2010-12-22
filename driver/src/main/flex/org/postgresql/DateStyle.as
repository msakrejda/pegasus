package org.postgresql {

    /**
     * Class related to the representations of dates in PostgreSQL.
     */
    public class DateStyle {
        public static const OUTPUT_ISO:String = 'ISO';
        public static const OUTPUT_POSTGRES:String = 'Postgres';
        public static const OUTPUT_SQL:String = 'SQL';
        public static const OUTPUT_GERMAN:String = 'German';

        public static const ORDER_MDY:String = 'MDY';
        public static const ORDER_DMY:String = 'DMY';
        public static const ORDER_YMD:String = 'YMD';

        /**
         * Parse the server DateStyle string into the tuple
         * (output format, mdy order) as an array.
         */
        public static function parse(value:String):Array {
            var result:Array = value.split(', ');
            if (result.length != 2) {
                throw new ArgumentError("Invalid DateStyle string: " + value);
            } else {
                return result;
            }
        }
    }
}