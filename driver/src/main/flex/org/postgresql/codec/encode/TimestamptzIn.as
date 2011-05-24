package org.postgresql.codec.encode {
    import org.postgresql.UnsupportedProtocolFeatureError;
    import org.postgresql.Oid;
    import org.postgresql.util.DateFormatter;
    import org.postgresql.EncodingFormat;
    import org.postgresql.codec.IPGTypeEncoder;
    import org.postgresql.io.ICDataOutput;

    /**
     * Formats dates as UTC dates.
     */
    public class TimestamptzIn implements IPGTypeEncoder {
        private var _dateFormatter:DateFormatter;
        private var _sendUTC:Boolean;

        /**
         * Constructor.
         *
         * @param formatter DateFormatter instance to use for sending timestamps in TEXT-mode
         * @param sendUTC whether to send incoming timestamps as UTC or local time
         */
        public function TimestamptzIn(formatter:DateFormatter, sendUTC:Boolean) {
             _dateFormatter = formatter;
             _sendUTC = sendUTC;
        }

        /**
         * @inheritDoc
         */
        public function encode(bytes:ICDataOutput, value:Object, format:int, serverParams:Object):void {
            switch (format) {
                case EncodingFormat.TEXT:
                    var dateVal:Date = value as Date;
                    var formatted:String = _dateFormatter.format(dateVal);
                    // We need to specify time zone, or PostgreSQL will interpret the timestamp
                    // in the server time zone, which is rarely what we want.
                    if (_sendUTC) {
                        formatted += ' UTC';
                    } else {
                        // The timezone offset uses the somewhat weird format of +/-HMM
                        formatted += int(dateVal.timezoneOffset / 60) * 100 + (dateVal.timezoneOffset % 60);
                    }
                    bytes.writeUTFBytes(formatted);
                    break;
                case EncodingFormat.BINARY:
                    // See note in DateOut
                    throw new UnsupportedProtocolFeatureError("Binary format not supported");
                    break;
                default:
                    throw new ArgumentError("Unknown format: " + format);
            }
        }

        /**
         * @inheritDoc
         */
        public function getInputOid(clazz:Class):int {
            return Oid.TIMESTAMPTZ;
        }
    }
}
