package org.postgresql.febe {

    /**
     *  Basic <code>IFieldInfo</code> implementation, largely for testing.
     */
    public class BasicFieldDescription implements IFieldInfo {

        private var _typeOid:int;
        private var _format:int;

        /**
         * Constructor
         *
         * @param format format of this parameter
         * @param oid server-side type of this parameter
         *
         * @private
         */
        public function BasicFieldDescription(oid:int, format:int) {
            _typeOid = oid;
            _format = format;
        }

        /**
         * @inheritDoc
         */
        public function get format():int { return _format; }

        /**
         * @inheritDoc
         */
        public function get typeOid():int { return _typeOid; }

    }
}