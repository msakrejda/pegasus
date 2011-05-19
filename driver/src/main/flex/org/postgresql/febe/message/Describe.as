package org.postgresql.febe.message {

    import org.postgresql.febe.message.AbstractMessage;
    import org.postgresql.febe.message.IFEMessage;
    import org.postgresql.febe.message.MessageError;
    import org.postgresql.io.ICDataOutput;

    public class Describe extends AbstractMessage implements IFEMessage {

        public static const PORTAL:String = 'P';
        public static const STATEMENT:String = 'S';

        private var _name:String;
        private var _type:String;

        public function Describe(name:String, type:String) {
            _name = name;
            if (type != PORTAL && type != STATEMENT) {
                throw new MessageError("unknown describe type: " + type, this);
            }
            _type = type;
        }

        public function write(out:ICDataOutput):void {
            out.writeByte(code('D'));
            var len:int = 4 + 1 + _name.length + 1;
            out.writeInt(len);
            out.writeByte(code(_type));
            out.writeCString(_name);
        }

        public override function toString():String {
            return super.toString() + ' {' + _type + ' ' + _name + '}';
        }

    }
}