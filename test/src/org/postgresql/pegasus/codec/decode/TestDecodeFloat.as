package org.postgresql.pegasus.codec.decode {

    import org.flexunit.Assert;
    import org.postgresql.EncodingFormat;
    import org.postgresql.Oid;
    import org.postgresql.codec.decode.FloatOut;
    import org.postgresql.febe.BasicFieldDescription;
    import org.postgresql.febe.IFieldInfo;
    import org.postgresql.io.ByteDataStream;

    [RunWith("org.flexunit.runners.Parameterized")]
    public class TestDecodeFloat {
        private var _decoder:FloatOut;

        [Before]
        public function setup():void {
            _decoder = new FloatOut();
        }

        public static function getTestFloats():Array {
            var format:BasicFieldDescription = new BasicFieldDescription(Oid.FLOAT4, EncodingFormat.TEXT);
            var params:Object = {};
            return [
                [ getBytes('0'), format, params, 0 ],
                [ getBytes('1'), format, params, 1 ],
                [ getBytes('-1'), format, params, -1 ],
                /*
                    The Number.MAX_VALUE tests fail right now due to some interesting properties of the Flash Player
                    platform: Number(String(Integer.MAX_VALUE)) != Integer.MAX_VALUE . Not sure if this is a Flash Player
                    problem or reasonable (but definitely unintuitive) behavior.
                [ getBytes(String(Number.MAX_VALUE)), format, params, Number.MAX_VALUE ],
                [ getBytes(String(-Number.MAX_VALUE)), format, params, -Number.MAX_VALUE ],
                */
                [ getBytes(String(Number.MIN_VALUE)), format, params, Number.MIN_VALUE ],
                [ getBytes(String(-Number.MIN_VALUE)), format, params, -Number.MIN_VALUE ],
                [ getBytes('Infinity'), format, params, Infinity ],
                [ getBytes('-Infinity'), format, params, -Infinity ],
                [ getBytes('NaN'), format, params, NaN ]
            ];
        }

        [Test(dataProvider="getTestFloats")]
        public function testDecodeFloat(bytes:ByteDataStream, format:IFieldInfo, serverParams:Object, expected:Number):void {
            var result:Number = _decoder.decode(bytes, format, serverParams) as Number;
            // Unfortunately, FlexUnit assertions are still somewhat pathetic
            if (isNaN(expected)) {
                Assert.assertTrue(isNaN(result));
            } else {
                Assert.assertEquals(expected, result);
            }
        }

    }
}