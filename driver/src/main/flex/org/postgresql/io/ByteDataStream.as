package org.postgresql.io {

    import flash.utils.ByteArray;

    /**
     * An <code>IDataStream</code> backed by a ByteArray; useful for testing.
     */
    public class ByteDataStream extends ByteArray implements ICDataInput, ICDataOutput {

        /**
         * @inheritDoc
         */
        public function readCString():String {
            return IOUtil.readCString(this);
        }

        /**
         * @inheritDoc
         */
        public function writeCString(value:String):void {
            IOUtil.writeCString(this, value);
        }

        /**
         * @inheritDoc
         */
        public function close():void {
            /* do nothing */
        }
    }
}