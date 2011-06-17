package org.postgresql.febe {
    import flash.utils.ByteArray;

    /**
     * Describes a parameter and how it will be passed to the PostgreSQL backend.
     */
    public class ArgumentInfo implements IFieldInfo {
        private var _format:int;
        private var _value:ByteArray;
        private var _oid:int;

        /**
         * @private
         */
        public function ArgumentInfo(format:int, oid:int, value:ByteArray) {
            _format = format;
            _oid = oid;
            _value = value;
        }

        /**
         * The encoding format of this parameter.
         * @see org.postgresql.EncodingFormat
         */
        public function get format():int {
            return _format;
        }

        /**
         * The PostgreSQL oid of this parameter.
         * @see org.postgresql.Oid
         */
        public function get typeOid():int {
            return _oid;
        }

        /**
         * The raw bytes for this parameter value, as encoded according to the
         * specified format.
         */
        public function get value():ByteArray {
            return _value;
        }
    }
}
