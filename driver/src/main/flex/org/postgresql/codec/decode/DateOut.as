package org.postgresql.codec.decode {

    import org.postgresql.Oid;
    import org.postgresql.DateStyle;
    import org.postgresql.EncodingFormat;
    import org.postgresql.codec.IPGTypeDecoder;
    import org.postgresql.febe.IFieldInfo;
    import org.postgresql.UnsupportedProtocolFeatureError;
    import org.postgresql.io.ICDataInput;
    import org.postgresql.util.DateUtil;

    public class DateOut implements IPGTypeDecoder {
        // Currently, we only support ISO-style date parsing, and only text mode

        public function decode(bytes:ICDataInput, format:IFieldInfo, serverParams:Object):Object {
            switch (format.format) {
                case EncodingFormat.TEXT:
                    switch (format.typeOid) {
                        case Oid.TIMESTAMP:
                        case Oid.TIMESTAMPTZ:
                            if (!('DateStyle' in serverParams)) {
                                throw new ArgumentError("No DateStyle specified");
                            }
                            var outputStyle:String = DateStyle.getOutputFormat(serverParams['DateStyle']);
                            if (outputStyle != DateStyle.OUTPUT_ISO) {
                                throw new ArgumentError("Unsupported output DateStyle: " + outputStyle);
                            }
                            var dateStr:String = bytes.readUTFBytes(bytes.bytesAvailable);
                            // Unfortunately, ActionScript does not have infinite dates: this is probably
                            // a reasonable workaround for the moment
                            if (dateStr == 'infinity') {
                                return new Date(DateUtil.MAX_DATE_TICKS);
                            } else if (dateStr == '-infinity') {
                                return new Date(DateUtil.MIN_DATE_TICKS);
                            } else {
                                return parseISO(dateStr);
                            }
                            break;
                        default:
                            throw new ArgumentError("Unable to decode oid: " + format.typeOid);
                    }
                case EncodingFormat.BINARY:
                    // TODO: implement me. on the wire, the value here depends on
                    // whether we have integer datetimes. After we parse this, we
                    // need to treat it as a microsencond offset since 2000 (not 1970).
                    throw new UnsupportedProtocolFeatureError("Binary format not supported");
                default:
                    throw new ArgumentError("Unknown format: " + format.format);
            }
        }

        private function parseISO(dateStr:String):Date {
            // this parses strings in the format
            // y y y y - M M - d d  h h : m m : s s (.fraction)?(tz:mm)?
            // 0         5     8    11    14    17    20
            var year:int = int(dateStr.substr(0, 4));
            var mon:int = int(dateStr.substr(5, 2));
            var day:int = int(dateStr.substr(8, 2));

            var hour:int = int(dateStr.substr(11, 2));
            var min:int = int(dateStr.substr(14, 2));
            var sec:int = int(dateStr.substr(17, 2));

            var millis:int;
            // This may not be present. In the degenerate case,
            // this will be equal to the length of the string
            // and will help us calculate milliseconds, if present.
            var tzSignIdx:int = 19;
            var tzOffset:Number;

            while (tzSignIdx < dateStr.length &&
                   dateStr.charAt(tzSignIdx) != '-' &&
                   dateStr.charAt(tzSignIdx) != '+') {
                tzSignIdx++;
            }

            if (dateStr.charAt(19) == '.') {
                millis = int(Number(dateStr.substr(19, tzSignIdx - 19)) * 1000);
            } else {
                millis = 0;
            }

            if (tzSignIdx != dateStr.length) {
                var tzOffHours:Number = int(dateStr.substr(tzSignIdx + 1, 2));
                var tzOffMin:Number;
                if (tzSignIdx + 3 < dateStr.length) {
                    tzOffMin = int(dateStr.substr(tzSignIdx + 3, 2));
                } else {
                    tzOffMin = 0;
                }
                tzOffset = (dateStr.charAt(tzSignIdx) == '+' ? 1 : -1) * ((tzOffHours * 60) + tzOffMin);
            } else {
                tzOffset = NaN;
            }
            var result:Date = new Date(year, mon - 1 /* 0-numbered months (!) */, day, hour, min, sec, millis);
            if (!isNaN(tzOffset)) {
                // timezoneOffset is ready-only, so we cannot manipulate it here. Essentially,
                // all dates in ActionScritpt are going to be in the client's timezone. If a
                // timezone offset is specified, we need to adjust the date by the difference
                // between our timezone and tzoffset. Note that due to some fantastically
                // creative API design, time zones "behind" GMT actually have positive offsets,
                // and timezones "ahead of" GMT have negative offsets, so we add instead of
                // subtracting.
                var tzDiff:Number = tzOffset + result.timezoneOffset;
                if (tzDiff != 0) {
                    result.time += tzDiff * 1000 * 60;
                }
            }
            return result;
        }

        public function getOutputClass(typeOid:int):Class {
            return Date;
        }
    }
}