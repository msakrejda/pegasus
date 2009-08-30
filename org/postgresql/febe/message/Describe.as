package org.postgresql.febe.message
{
    import flash.utils.IDataOutput;

    public class Describe extends AbstractMessage implements IFEMessage
    {
        public static const PORTAL:String = 'P';
        public static const PREPARED_STATEMENT:String = 'S';
        
        private var _name:String;
        private var _type:String;

        public function Describe(name:String, type:String)
        {
            _name = name;
            if (type != PORTAL && type != PREPARED_STATEMENT) {
                throw new MessageError("unknown describe type: " + type, this);
            }
            _type = type;
        }
        
        public function write(out:IDataOutput):void
        {
            out.writeByte(code('D'));
            var len:int = 4 + _name.length + 1;
            out.writeInt(len);
            writeCString(out, _name);
        }
        
    }
}