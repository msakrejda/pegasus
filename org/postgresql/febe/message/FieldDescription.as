package org.postgresql.febe.message
{
    public class FieldDescription
    {
        public var name:String;
        public var tableOid:int;
        public var attributeNum:int;
        public var typeOid:int;
        public var typeModifier:int;
        public var size:int;
        public var format:int;
    }
}