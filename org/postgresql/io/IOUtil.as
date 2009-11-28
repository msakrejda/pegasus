package org.postgresql.io {

    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;

    // TODO: FlexBuilder seems to crap all over itself when faced with a top-level
    // function, so we're using a wrapper class with static methods for now.
    // We should investigate if there's a workaround--a class with static methods
    // offers no benefit over top-level (properly namespaced) functions.
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