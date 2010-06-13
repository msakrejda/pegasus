package org.postgresql.db {
    public class Column {
        public function Column(name:String, type:Class, typeOid:int) {
            this.name = name;
            this.type = type;
            this.typeOid = typeOid;
        }
        public var name:String;
        public var type:Class;
        public var typeOid:int;
    }
}