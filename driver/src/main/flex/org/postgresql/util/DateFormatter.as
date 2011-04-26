package org.postgresql.util {

    /**
     * Utility class for formatting dates as Strings. Attempts to closely mirror the API
     * of the Flex DateFormatter, though also supports escaping the pattern letters (precede
     * with a backslash). The Flex DateFormatter API is rather loosely defined, but:
     * <pre>
     * Y{2,4}:    Year, two or four digits
     * M{1,4}:    Month (single number / padded to two digits / three-letter abbreviation / full name)
     * D{1,2}:    Day of month, padded to specified length if necessary
     * E{1,4}:    Day of week (single number / padded to two digits / three-letter abbreviation / full name)
     * A:         AM / PM indicator
     * J{1,2}:    Hour in day (0-23), padded to specified length if necessary
     * H{1,2}:    Hour in day (1-24), padded to specified length if necessary
     * K{1,2}:    Hour in day (0-11), padded to specified length if necessary
     * L{1,2}:    Hour in day (1-12), padded to specified length if necessary
     * N{1,2}:    Minutes, padded to specified length if necessary
     * S{1,2}:    Seconds, padded to specified length if necessary
     * Q{1,3}:    Milliseconds, padded to specified length if necessary
     * </pre>
     * Note that, unlike internally, months are one-indexed. Date formatting is not currently localizable.
     * However, the properties that map to the long and short form of day and month names, as well as
     * the <code>am</code> / <code>pm</code> indicator properties, are all public instances properties
     * which can be redefined in a given instance of the formatter.
     */
    public class DateFormatter {

        /**
         * Short-form (three-letter) names for the months of the year, in calendar order.
         */
        public var months:Array = [
            'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
        ];

        /**
         * Long-form (full) names for the months of the year, in calendar order.
         */
        public var fullMonths:Array = [
            'January', 'February', 'March', 'April', 'May', 'June', 'July',
            'August', 'September', 'October', 'November', 'December'
        ];

        /**
         * Short-form (three-letter) names for the days of the week, in order (starting with Sunday).
         */
        public var daysOfWeek:Array = [
            'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'
        ];

        /**
         * Long-form (full) names for hte days of the week, in order (starting with Sunday).
         */
        public var fullDaysOfWeek:Array = [
            'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
        ];

        /**
         * A.M. indicator.
         */
        public var am:String = 'a.m.';

        /**
         * P.M. indicator.
         */
        public var pm:String = 'p.m.';

        /**
         * Format string to specify how dates should be formatted. See main class documentation for details.
         */
        public var formatString:String;

        /**
         * Format the given date according to the current format string.
         *
         * @param value Date to format.
         * @return String representation of this Date
         */
        public function format(value:Date):String {
            // This function ain't pretty...

            // 2 to 4 Y or 1 to 4 of [ME] or 1 to 2 of [DJHKLNS] or A, *not* preceeded by a backslash
            return formatString.replace(/(?<!\\)(?:YY+|[ME]{1,4}|[DJHKLNS]{1,2}|Q{1,3}|A)/g, function():String {
                var match:String = arguments[0];
                if (/Y+/.test(match)) {
                    // Let's assume we're logging between 1000 AD and 9999 AD; they will curse us on y10k
                    return value.fullYear.toString().slice(4 - match.length);
                } else if (/M+/.test(match)) {
                    // N.B.: months are zero-indexed
                    var monthIndex:int = value.month;
                    var monthVal:String = (monthIndex + 1).toString();
                    if (match.length <= 2) {
                        return zeroPad(monthVal, match.length);
                    } else if (match.length == 3) {
                        return months[monthIndex];
                    } else if (match.length == 4) {
                        return fullMonths[monthIndex];
                    } else {
                        assert("Unexpected month format match: " + match, false);
                        return '???';
                    }
                } else if (/D+/.test(match)) {
                    var dayVal:String = value.date.toString();
                    if (match.length <= 2) {
                        return zeroPad(dayVal, match.length);
                    } else {
                        assert("Unexpected day format match: " + match, false);
                        return '??';
                    }
                } else if (/E+/.test(match)) {
                    var dayOfWeekIdx:int = value.day;
                    if (match.length <= 2) {
                        return zeroPad(dayOfWeekIdx.toString(), match.length);
                    } else if (match.length == 3) {
                        return daysOfWeek[dayOfWeekIdx];
                    } else if (match.length == 4) {
                        return fullDaysOfWeek[dayOfWeekIdx];
                    } else {
                        assert("Unexpected day of week format match: " + match, false);
                        return '??';
                    }
                } else if (/[JHKL]+/.test(match)) {
                    // KL are on the twelve-hour clock, and HL are one-indexed
                    var hours:int = value.hours;
                    var adjustedHours:int = hours;
                    if (/[KL]+/.test(match)) {
                        adjustedHours = hours % 12;
                    }
                    if (/[HL]+/.test(match) && adjustedHours == 0) {
                        adjustedHours = 12;
                    }
                    var hoursVal:String = adjustedHours.toString();
                    return zeroPad(hoursVal, match.length);
                } else if (/N/.test(match)) {
                    var minutesVal:String = value.minutes.toString();
                    return zeroPad(minutesVal, match.length);
                } else if (/S/.test(match)) {
                    var secondsVal:String = value.seconds.toString();
                    return zeroPad(secondsVal, match.length);
                } else if (/Q/.test(match)) {
                    var millisVal:String = value.milliseconds.toString();
                    return zeroPad(millisVal, match.length);
                } else if (/A/.test(match)) {
                    return value.hours < 12 ? am : pm;
                } else {
                    assert("Unexpected format match: " + match, false);
                    return '??';
                }
            }).replace(/\\([YMEDJHKLNSQA])/g, '$1');
        }

        // pad to specified length using '0'
        private function zeroPad(value:String, padLen:int):String {
            if (value.length >= padLen) {
                return value;
            } else if (value.length == padLen - 1) {
                return '0' + value;
            } else if (value.length == padLen - 2) {
                return '00' + value;
            } else {
                // We don't currently use this, but it's here
                // for completeness; we can certainly optimize this
                return zeroPad('000' + value, padLen - 3);
            }
        }
    }
}