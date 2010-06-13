package org.postgresql.febe {

    public class BasicFieldDescription implements IFieldInfo {

        private var _typeOid:int;
        private var _format:int;

        public function BasicFieldDescription(oid:int, format:int) {
            _typeOid = oid;
            _format = format;
        }
        
        public function get format():int { return _format; }
        public function get typeOid():int { return _typeOid; }

    }
}