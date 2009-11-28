package org.postgresql.io {

    import flash.utils.ByteArray;

    public class ByteDataStream extends ByteArray implements ICDataInput {

        public function readCString():String {
            return IOUtil.readCString(this);
        }

    }
}