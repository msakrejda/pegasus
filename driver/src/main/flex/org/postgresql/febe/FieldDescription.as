package org.postgresql.febe {

    import org.postgresql.io.ICDataInput;

    public class FieldDescription {

        public var name:String;
        public var tableOid:int;
        public var attributeNum:int;
        public var typeOid:int;
        public var typeSize:int;
        public var typeModifier:int;
        public var format:int;

        public function read(input:ICDataInput):void {
            name = input.readCString();
            tableOid = input.readInt();
            attributeNum = input.readShort();
            typeOid = input.readInt();
            typeSize = input.readShort();
            typeModifier = input.readInt();
            format = input.readShort();
            EncodingFormat.validate(format);
        }

    }
}