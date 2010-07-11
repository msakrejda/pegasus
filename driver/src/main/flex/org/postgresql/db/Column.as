package org.postgresql.db {
    internal class Column implements IColumn {
        private var _name:String;
        private var _type:Class;
        private var _typeOid:int;
        public function Column(name:String, type:Class, typeOid:int) {
            _name = name;
            _type = type;
            _typeOid = typeOid;
        }
        public function get name():String { return _name; }
        public function get type():Class { return _type; }
        public function get typeOid():int { return _typeOid; }
    }
}