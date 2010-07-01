package org.postgresql.pegasus.codec.decode {

	import org.postgresql.io.ByteDataStream;

	public function getBytes(str:String):ByteDataStream {
		var bytes:ByteDataStream = new ByteDataStream();
		bytes.writeUTFBytes(str);
		bytes.position = 0;
		return bytes;				
	}

}