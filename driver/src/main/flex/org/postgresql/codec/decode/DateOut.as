package org.postgresql.codec.decode {

	import org.postgresql.codec.IPGTypeDecoder;
	import org.postgresql.febe.DateStyle;
	import org.postgresql.febe.EncodingFormat;
	import org.postgresql.febe.FieldDescription;
	import org.postgresql.io.ICDataInput;

	public class DateOut implements IPGTypeDecoder {

		public function decode(bytes:ICDataInput, format:FieldDescription, serverParams:Object):Object {
			case (format.format) {
				case EncodingFormat.TEXT:
		            if (!('DateStyle' in serverParams)) {
		                throw new ArgumentError("No DateStyle specified");
		            }
		            var outputStyle:String = DateStyle.parse(serverParams['DateStyle'])[0];
		            if (outputStyle != DateStyle.OUTPUT_ISO) {
		                throw new ArgumentError("Unsupported output DateStyle: " + outputStyle);
		            }
		            return parseISO(bytes.readUTFBytes(bytes.bytesAvailable));
		        case EncodingFormat.BINARY:
		            // TODO: implement me. on the wire, the value here depends on
		            // whether we have integer datetimes. After we parse this, we
		            // need to treat it as a microsencond offset since 2000 (not 1970).
		            return null;
		        default:
                    throw new ArgumentError("Unknown format: " + fieldInfo.format); 
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
            	millis = int(dateStr.substr(19, tzSignIdx - 19)) * 1000; 
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
            var result:Date = new Date(year, mon, day, hour, min, sec, millis);
            if (!isNaN(tzOffset)) {
            	result.timezoneOffset = tzOffset;
            }
            return result;
 		}
		
	}
}