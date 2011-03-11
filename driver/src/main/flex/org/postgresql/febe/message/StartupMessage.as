package org.postgresql.febe.message {

    import org.postgresql.febe.message.AbstractMessage;
    import org.postgresql.febe.message.IFEMessage;
    import org.postgresql.febe.message.MessageError;
    import org.postgresql.io.ICDataOutput;

    public class StartupMessage extends AbstractMessage implements IFEMessage {

        private static const PROTOCOL_VERSION:int = 196608;
        private var _parameters:Object;
        private var _paramLen:int;

        public function StartupMessage(parameters:Object) {
            if (!parameters) {
                throw new ArgumentError("parameters must not be null");
            }
            if (!('user' in parameters)) {
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

        public function write(out:ICDataOutput):void {
            var len:int = 4 + 4 + _paramLen + 1;
            out.writeInt(len);
            out.writeInt(PROTOCOL_VERSION);
            for (var parameter:String in _parameters) {
                out.writeCString(parameter);
                out.writeCString(_parameters[parameter]);
            }
            out.writeByte(0x00);
        }

    }
}