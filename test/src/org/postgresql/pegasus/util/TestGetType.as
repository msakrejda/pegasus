package org.postgresql.pegasus.util {

    import org.flexunit.Assert;
    import org.postgresql.util.getType;

    [RunWith("org.flexunit.runners.Parameterized")]
    public class TestGetType {

        public static function getTestTypes():Array {
            return [
               [ Number(42), Number ],
               /*
                * The behavior for int, uint and Number is *really* weird. Essentially, AS3 seems
                * to veer away from straight static typing here and do a sort of numerical
                * duck typing. The .constructor property for variables typed as int, uint, and
                * Number always returns Number, and the 'is' operator returns true if the given
                * number can be expressed with that type. E.g., (Number(42) is int) and
                * uint(42) is Number) are both true. Will add additional tests once getType
                * supports these types properly.

               [ uint(42), uint ],
               [ Number(42), Number ],

                */
               [ new Date(), Date ],
               [ 'hello world', String ],
               [ <hello><world/></hello>, XML ],
               [ XMLList(<hello/>), XMLList ]
            ];
        }

        [Test(dataProvider="getTestTypes")]
        public function testGetType(value:Object, expectedType:Class):void {
            var type:Class = getType(value);
            Assert.assertEquals(expectedType, type);
        }

    }
}