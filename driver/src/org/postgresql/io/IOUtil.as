package org.postgresql.io {

    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;

    /**
     * Internal helper class for stream method implementations. Ideally, these would
     * be shared in a better manner, but this is te simplest way to simplify implementation
     * across classes with distinct inheritance hierarchies.
     */
    internal class IOUtil {

        /**
         * Standard implementation for the <code>readCString</code> method on an
         * <code>ICDataInput</code> using underlying methods from
         * <code>IDataInput</code>.
         *
         * @param stream stream to read from
         * @return the String read
         */
        public static function readCString(stream:IDataInput):String {
            var strBytes:Array = [];
            var currByte:int;
            while ((currByte = stream.readByte()) != 0) {
                strBytes.push(currByte);
            }
            return String.fromCharCode.apply(null, strBytes);
        }


        /**
         * Standard implementation for the <code>writeCString</code> method on an
         * <code>ICDataOutput</code> using underlying methods from
         * <code>IDataOutput</code>.
         *
         * @param stream stream to write to
         * @param str String to write
         */
         public static function writeCString(stream:IDataOutput, str:String):void {
            stream.writeUTFBytes(str);
            stream.writeByte(0x00);
        }
    }

}