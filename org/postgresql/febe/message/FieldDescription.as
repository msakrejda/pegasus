package org.postgresql.febe.message {

    import org.postgresql.io.ICDataInput;

    public class FieldDescription {

        public static const FORMAT_TEXT:int = 0x00;
        public static const FORMAT_BINARY:int = 0x01;

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
            if (format != FORMAT_TEXT &&
                format != FORMAT_BINARY) {
                throw new ArgumentError("Unrecognized data encoding: " + format);
            }
        }

    }
}