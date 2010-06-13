package org.postgresql {

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