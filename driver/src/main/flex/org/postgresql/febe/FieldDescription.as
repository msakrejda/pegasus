package org.postgresql.febe {

    import org.postgresql.EncodingFormat;
    import org.postgresql.io.ICDataInput;

    public class FieldDescription implements IFieldInfo {

        public var name:String;
        public var tableOid:int;
        public var attributeNum:int;
        private var _typeOid:int;
        public var typeSize:int;
        public var typeModifier:int;
        private var _format:int;

        public function read(input:ICDataInput):void {
            name = input.readCString();
            tableOid = input.readInt();
            attributeNum = input.readShort();
            _typeOid = input.readInt();
            typeSize = input.readShort();
            typeModifier = input.readInt();
            _format = input.readShort();
            EncodingFormat.validate(format);
        }

        public function get typeOid():int {
            return _typeOid;
        }

        public function get format():int {
            return _format;
        }

    }
}