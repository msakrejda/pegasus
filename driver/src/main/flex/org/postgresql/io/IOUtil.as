package org.postgresql.io {

    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;

    internal class IOUtil {

	    public static function readCString(stream:IDataInput):String {
	        var strBytes:Array = [];
	        var currByte:int;
	        while ((currByte = stream.readByte()) != 0) {
	            strBytes.push(currByte);
	        }
	        return String.fromCharCode.apply(null, strBytes);
	    }

        public static function writeCString(stream:IDataOutput, str:String):void {
            stream.writeUTFBytes(str);
            stream.writeByte(0x00);
        }
    }

}