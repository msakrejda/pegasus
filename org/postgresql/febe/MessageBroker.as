package org.postgresql.febe
{
    import flash.events.EventDispatcher;
    import flash.events.ProgressEvent;
    import flash.utils.ByteArray;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    
    import org.postgresql.febe.message.IBEMessage;

    public class MessageBroker extends EventDispatcher
    {
        private var _backendMessageTypes:Object;
        private var _inputStream:IDataInput;
        private var _outputStream:IDataOutput;

        private var _nextMessageType:int;
        private var _nextMessageLen:int;

        public function MessageBroker(input:IDataInput, output:IDataOutput)
        {
            _backendMessageTypes = {};
            _inputStream = input;
            _outputStream = output;
            _nextMessageType = -1;
            _nextMessageLen = -1;
        }
        
        public function registerBEMessage(messageCode:String, message:Class):void {
            if (messageCode.length > 1) {
                throw new Error("Message code must be a single character");
            }
            _backendMessageTypes[messageCode.charCodeAt(0)] = message;
        }
        
        private function readNextMessage(e:ProgressEvent):void {
            if (_nextMessageLen != -1 && _inputStream.bytesAvailable >= _nextMessageLen) {
                readNextPayload();
            } else if (_nextMessageLen == -1 && _inputStream.bytesAvailable >= 5) {
                readNextHeader();
            }
        }

        private function readNextHeader():void {
            _nextMessageType = _inputStream.readByte();
            _nextMessageLen = _inputStream.readInt();
            if (_inputStream.bytesAvailable >= _nextMessageLen) {
                readNextPayload();
            }
        }

        private function readNextPayload():void {
            var nextMessage:IBEMessage = new _backendMessageTypes[_nextMessageType]();
            // TODO: we should not need to copy things like this; if we can provide a
            // restricted view of the input stream, that will be enough
            var nextMessageBytes:ByteArray = new ByteArray();
            _inputStream.readBytes(nextMessageBytes, 0, _nextMessageLen);
            nextMessage.read(nextMessageBytes);
            _nextMessageType = -1;
            _nextMessageLen = -1;
            if (_inputStream.bytesAvailable >= 5) {
                readNextHeader();
            }
        }

        
    }
}