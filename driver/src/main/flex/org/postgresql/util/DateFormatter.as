package org.postgresql.util
{
	import flash.utils.Dictionary;
	
	/**
	 * Attempts to closely mirror the API of the Flex DateFormatter, though also supports
	 * escaping the pattern letters (precede with a backslash). The Flex DateFormatter API
	 * is rather loosely defined, but:
	 *
	 * Y{2,4}:	Year, two or four digits (technically allows three as well)
	 * M{1,4}:	Month (single number / padded to two digits / three-letter abbreviation / full name)
	 * D{1,2}:	Day of month (padded to specified length if necessary)
	 * E{1,4}:	Day of week (single number / padded to two digits / three-letter abbreviation / full name)
	 * A:		AM / PM indicator
	 * J{1,2}:	Hour in day (0-23), padded to two digits if necessary
 	 * H{1,2}:	Hour in day (1-24), padded to two digits if necessary
   	 * K{1,2}:	Hour in day (0-11), padded to two digits if necessary
 	 * L{1,2}:	Hour in day (1-12), padded to two digits if necessary
 	 * N{1,2}:	Minute in hour, padded to two digits if necessary
 	 * S{1,2}:	Second in hour, padded to two digits if necessary
	 *
	 * Note that, unlike internally, months are one-indexed. Date formatting is not currently localizable.
	 */
	public class DateFormatter
	{
		public var months:Array = [
			'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
		];

		public var fullMonths:Array = [
			'January', 'February', 'March', 'April', 'May', 'June', 'July',
			'August', 'September', 'October', 'November', 'December'
		];

		public var daysOfWeek:Array = [
			'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'
		];

		public var fullDaysOfWeek:Array = [
			'Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'
		];

		public var am:String = 'a.m.';
		public var pm:String = 'p.m.';

		public var formatString:String;
		public function format(value:Date):String {
			// This function ain't pretty...

			// 2 to 4 Y or 1 to 4 of [ME] or 1 to 2 of [DJHKLNS] or A, *not* preceeded by a backslash
			return formatString.replace(/(?<!\\)(?:YY+|[ME]{1,4}|[DJHKLNS]{1,2}|A)/g, function():String {
				var match:String = arguments[0];
				if (/Y+/.test(match)) {
					// Let's assume we're logging between 1000 AD and 9999 AD; they will curse us on y10k
					return value.fullYear.toString().slice(4 - match.length);
				} else if (/M+/.test(match)) {
					// N.B.: months are zero-indexed
					var monthIndex:int = value.month;
					var monthVal:String = (monthIndex + 1).toString();
					if (match.length == 1 || (match.length == 2 && monthVal.length == 2)) {
						return monthVal;
					} else if (match.length == 2) {
						return '0' + monthVal;
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
					if (match.length == 1 || (match.length == 2 && dayVal.length == 2)) {
						return dayVal;
					} else if (match.length == 2) {
						return '0' + dayVal;
					} else {
						assert("Unexpected day format match: " + match, false);
						return '??';
					}
				} else if (/E+/.test(match)) {
					var dayOfWeekIdx:int = value.day;
					if (match.length == 1) {
						return dayOfWeekIdx.toString();
					} else if (match.length == 2) {
						// There are only seven days of the week, so we always pad
						return '0' + dayOfWeekIdx;
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

					if (match.length == 1 || (match.length == 2 && hoursVal.length == 2)) {
						return hoursVal;
					} else {
						return '0' + hoursVal;
					}
				} else if (/N/.test(match)) {
					var minutesVal:String = value.minutes.toString();
					if (match.length == 1 || (match.length == 2 && minutesVal.length == 2)) {
						return minutesVal;
					} else {
						return '0' + minutesVal;
					}
				} else if (/S/.test(match)) {
					var secondsVal:String = value.seconds.toString();
					if (match.length == 1 || (match.length == 2 && secondsVal.length == 2)) {
						return secondsVal;
					} else {
						return '0' + secondsVal;
					}
				} else if (/A/.test(match)) {
					return value.hours < 12 ? am : pm;
				}else {
					assert("Unexpected format match: " + match, false);
					return '??';
				}
			}).replace(/\\([YMEDJHKLNSA])/g, '$1');
		}
	}
}