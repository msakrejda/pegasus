package org.postgresql.pegasus.util {
    import org.flexunit.Assert;
    import org.postgresql.util.DateFormatter;

    [RunWith("org.flexunit.runners.Parameterized")]
    public class TestDateFormatter {

        private var _formatter:DateFormatter;

        [Before]
        public function setup():void {
            _formatter = new DateFormatter();
        }

        public static function getTestDates():Array {
            return [
                // N.B.: the month is zero-indexed in the Date constructor
                [ new Date(2134, 4, 6, 7, 8, 9), 'YY', '34' ],
                [ new Date(2134, 4, 6, 7, 8, 9), 'YYYY', '2134' ],
                [ new Date(2134, 4, 6, 7, 8, 9), 'M', '5' ],
                [ new Date(2134, 9, 6, 7, 8, 9), 'M', '10' ],
                [ new Date(2134, 4, 6, 7, 8, 9), 'MM', '05' ],
                [ new Date(2134, 9, 6, 7, 8, 9), 'MM', '10' ],
                [ new Date(2134, 5, 6, 7, 8, 9), 'MMM', 'Jun' ],
                [ new Date(2134, 3, 6, 7, 8, 9), 'MMMM', 'April' ],
                [ new Date(2134, 4, 6, 7, 8, 9), 'D', '6' ],
                [ new Date(2134, 4, 26, 7, 8, 9), 'D', '26' ],
                [ new Date(2134, 4, 6, 7, 8, 9), 'DD', '06' ],
                [ new Date(2134, 4, 26, 7, 8, 9), 'DD', '26' ],
                [ new Date(2134, 4, 6, 7, 8, 9), 'J', '7' ],
                [ new Date(2134, 4, 6, 17, 8, 9), 'J', '17' ],
                [ new Date(2134, 4, 6, 7, 8, 9), 'JJ', '07' ],
                [ new Date(2134, 4, 6, 17, 8, 9), 'JJ', '17' ],
                [ new Date(2134, 4, 6, 7, 8, 9), 'N', '8' ],
                [ new Date(2134, 4, 6, 7, 18, 9), 'N', '18' ],
                [ new Date(2134, 4, 6, 7, 8, 9), 'NN', '08' ],
                [ new Date(2134, 4, 6, 7, 18, 9), 'NN', '18' ],
                [ new Date(2134, 4, 6, 7, 8, 9), 'S', '9' ],
                [ new Date(2134, 4, 6, 7, 18, 19), 'S', '19' ],
                [ new Date(2134, 4, 6, 7, 8, 9), 'SS', '09' ],
                [ new Date(2134, 4, 6, 7, 18, 19), 'SS', '19' ],
                [ new Date(2134, 4, 6, 7, 8, 9), 'YYYY-MM-DD JJ:NN:SS', '2134-05-06 07:08:09' ],
                [ new Date(2134, 4, 6, 7, 8, 9), '\\Y\\Y\\Y\\Y-\\M\\M-\\D\\D \\J\\J:\\N\\N:\\S\\S', 'YYYY-MM-DD JJ:NN:SS' ]
            ];
        }

        [Test(dataProvider="getTestDates")]
        public function testFormatDate(date:Date, formatString:String, expected:String):void {
            _formatter.formatString = formatString;
            var result:String = _formatter.format(date);
            Assert.assertEquals(expected, result);
        }

    }
}