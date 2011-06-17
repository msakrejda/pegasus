package org.postgresql {

    /**
     * Class related to encodings of data in the protocol.
     */
    public class EncodingFormat {
        /**
         * The PostgreSQL text format. This is essentially equivalent to how datatypes
         * are presented through <code>psql</code>.
         */
        public static const TEXT:int = 0;
        /**
         * The PostgreSQL binary format. This is a custom binary format.
         */
        public static const BINARY:int = 1;
        /**
         * Utility function to validate the given format. Does nothing if the format
         * is valid; throws an ArgumentError otherwise.
         *
         * @param format format to validate
         * @throws ArgumentError if format is not recognized
         * @see #TEXT
         * @see #BINARY
         */
        public static function validate(format:int):void {
            if (format != TEXT && format != BINARY) {
                throw new ArgumentError("Unrecognized encoding format: " + format);
            }
        }
    }
}