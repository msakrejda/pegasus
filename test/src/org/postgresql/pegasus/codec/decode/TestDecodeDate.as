package org.postgresql.pegasus.codec.decode {
	import org.flexunit.Assert;
	import org.flexunit.asserts.assertEquals;
	import org.postgresql.DateStyle;
	import org.postgresql.EncodingFormat;
	import org.postgresql.Oid;
	import org.postgresql.codec.decode.DateOut;
	import org.postgresql.febe.BasicFieldDescription;
	import org.postgresql.febe.IFieldInfo;
	import org.postgresql.io.ByteDataStream;

	[RunWith("org.flexunit.runners.Parameterized")]
	public class TestDecodeDate {
		private var _decoder:DateOut;

		[Before]
		public function setup():void {
			_decoder = new DateOut();
		}
		
		private static function getBytes(str:String):ByteDataStream {
			var bytes:ByteDataStream = new ByteDataStream();
			bytes.writeUTFBytes(str);
			bytes.position = 0;
			return bytes;				
		};

		public static function getTestDates():Array {
			var format:BasicFieldDescription = new BasicFieldDescription(Oid.TIMESTAMP, EncodingFormat.TEXT);
			var params:Object = { DateStyle: DateStyle.OUTPUT_ISO + ', ' + DateStyle.ORDER_YMD };
			return [
				[ getBytes('2000-01-01 00:00:00'), format, params, new Date(2000, 0, 1, 0, 0, 0) ]
			];
		}

//		[Test]
//		public function testFoo():void { trace('hello world'); }

		[Test(dataProvider="getTestDates")]
		public function testDecodeDate(bytes:ByteDataStream, format:IFieldInfo, serverParams:Object, expected:Date):void {
			var result:Date = _decoder.decode(bytes, format, serverParams) as Date;
			Assert.assertEquals(expected.time, result.time);
		}

	}
}