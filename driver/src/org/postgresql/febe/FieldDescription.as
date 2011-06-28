package org.postgresql.febe {

    import org.postgresql.EncodingFormat;
    import org.postgresql.io.ICDataInput;

    /**
     * Default <code>IColumnInfo</code> implementation.
     */
    public class FieldDescription implements IColumnInfo {

        private var _name:String;
        public var tableOid:int;
        public var attributeNum:int;
        private var _typeOid:int;
        public var typeSize:int;
        public var typeModifier:int;
        private var _format:int;

        /**
         * Deserialize according to PostgreSQL field metadata encoding.
         *
         * @param input ICDataInput containing FieldDescription bytes
         */
        public function read(input:ICDataInput):void {
            _name = input.readCString();
            tableOid = input.readInt();
            attributeNum = input.readShort();
            _typeOid = input.readInt();
            typeSize = input.readShort();
            typeModifier = input.readInt();
            _format = input.readShort();
            EncodingFormat.validate(format);
        }

        /**
         * @inheritDoc
         */
        public function get typeOid():int {
            return _typeOid;
        }

        /**
         * @inheritDoc
         */
        public function get format():int {
            return _format;
        }

        /**
         * @inheritDoc
         */
        public function toString():String {
            return name + '(oid:' + _typeOid + ',attno:' + attributeNum + ',size:' + typeSize + ',typmod:' + typeModifier + ')';
        }

        /**
         * @inheritDoc
         */
        public function get name():String {
            return _name;
        }

    }
}