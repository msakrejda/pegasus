package org.postgresql {

    /**
     * Class related to encodings of data in the protocol.
     */
    public class EncodingFormat {
        public static const TEXT:int = 0;
        public static const BINARY:int = 1;
        public static function validate(format:int):void {
            if (format != TEXT && format != BINARY) {
                throw new ArgumentError("Unrecognized encoding format: " + format);
            }
        }
    }
}