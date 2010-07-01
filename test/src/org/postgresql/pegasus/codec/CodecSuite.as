package org.postgresql.pegasus.codec {
	import org.postgresql.pegasus.codec.decode.TestDecodeDate;
	import org.postgresql.pegasus.codec.decode.TestDecodeFloat;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class CodecSuite {
		public var dateTest:TestDecodeDate;
		public var floatTest:TestDecodeFloat;
	}
}