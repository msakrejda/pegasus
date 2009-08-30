package org.postgresql.febe.message
{
    import flash.utils.IDataOutput;

    public class StartupMessage extends AbstractMessage implements IFEMessage
    {
        private static const PROTOCOL_VERSION:int = 196608;
        private var _parameters:Object;
        private var _paramLen:int;

        public function StartupMessage(parameters:Object)
        {
            if (!(user in parameters)) {
                throw new MessageError("StartupMessage must include user", this);
            }
            _parameters = parameters;
            for (var parameter:String in _parameters) {
                var value:Object = _parameters[parameter];
                if (!(value is String)) {
                    value = String(value);
                    _parameters[parameter] = value; 
                }
                _paramLen += parameter.length + 1 + value.length + 1;
            }
        }

        public function write(out:IDataOutput):void
        {
            var len:int = 4 + 4 + _paramLen + 1;
            out.writeInt(len);
            out.writeInt(PROTOCOL_VERSION);
            for (var parameter:String in _parameters) {
                writeCString(out, parameter);
                writeCString(out, _parameters[parameter]);
            }
            out.writeByte(0x00); 
        }
        
    }
}