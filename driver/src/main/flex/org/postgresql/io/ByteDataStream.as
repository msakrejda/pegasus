package org.postgresql.io {

    import flash.utils.ByteArray;

    public class ByteDataStream extends ByteArray implements ICDataInput, ICDataOutput {

        public function readCString():String {
            return IOUtil.readCString(this);
        }

        public function writeCString(value:String):void {
            IOUtil.writeCString(this, value);
        }

        public function close():void {
            /* do nothing */
        }
    }
}