package org.postgresql.febe
{
    import flash.events.EventDispatcher;
    import flash.events.ProgressEvent;
    import flash.net.Socket;
    import flash.utils.ByteArray;
    
    import org.postgresql.febe.message.AuthenticationOk;
    import org.postgresql.febe.message.BackendKeyData;
    import org.postgresql.febe.message.CancelRequest;
    import org.postgresql.febe.message.CommandComplete;
    import org.postgresql.febe.message.DataRow;
    import org.postgresql.febe.message.Describe;
    import org.postgresql.febe.message.EmptyQueryResponse;
    import org.postgresql.febe.message.ErrorResponse;
    import org.postgresql.febe.message.Flush;
    import org.postgresql.febe.message.IBEMessage;
    import org.postgresql.febe.message.NoData;
    import org.postgresql.febe.message.NoticeResponse;
    import org.postgresql.febe.message.ParameterStatus;
    import org.postgresql.febe.message.PasswordMessage;
    import org.postgresql.febe.message.Query;
    import org.postgresql.febe.message.ReadyForQuery;
    import org.postgresql.febe.message.RowDescription;
    import org.postgresql.febe.message.StartupMessage;
    import org.postgresql.febe.message.Terminate;

    public class MessageBroker extends EventDispatcher
    {
        private var _backendMessageTypes:Object;

        private var _dataStream:Socket;

        private var _nextMessageType:int;
        private var _nextMessageLen:int;

        private function registerMessageTypes():void {
            registerBEMessage('', AuthenticationOk);
            registerBEMessage('', BackendKeyData);
            registerBEMessage('', CommandComplete);
            registerBEMessage('', DataRow);
            registerBEMessage('', EmptyQueryResponse);
            registerBEMessage('', ErrorResponse);
            registerBEMessage('', NoData);
            registerBEMessage('', NoticeResponse);
            registerBEMessage('', ParameterStatus);
            registerBEMessage('', ReadyForQuery);
            registerBEMessage('', RowDescription);
        }

        private var _dummyFEMessageRefs:Array = [
            CancelRequest, Describe, Flush, PasswordMessage, Query, StartupMessage, Sync, Terminate
        ];

        // The argument really should not be a Socket: it should be something that implements
        // all of IDataInput, IDataOutput, and EventDispatcher, but Socket doesn't really
        // offer that abstraction. We could probably wrap things to clean this up.
        public function MessageBroker(socket:Socket)
        {
            registerMessageTypes();
            _backendMessageTypes = {};

            _dataStream = socket;
            _dataStream.addEventListener(ProgressEvent.SOCKET_DATA, handleSocketData);

            _nextMessageType = -1;
            _nextMessageLen = -1;
        }
        
        public function registerBEMessage(messageCode:String, message:Class):void {
            if (messageCode.length > 1) {
                throw new Error("Message code must be a single character");
            }
            _backendMessageTypes[messageCode.charCodeAt(0)] = message;
        }
        
        private function handleSocketData(e:ProgressEvent):void {
            if (_nextMessageLen != -1 && _dataStream.bytesAvailable >= _nextMessageLen) {
                readNextPayload();
            } else if (_nextMessageLen == -1 && _dataStream.bytesAvailable >= 5) {
                readNextHeader();
            }
        }

        private function readNextHeader():void {
            _nextMessageType = _dataStream.readByte();
            _nextMessageLen = _dataStream.readInt();
            if (_dataStream.bytesAvailable >= _nextMessageLen) {
                readNextPayload();
            }
        }

        private function readNextPayload():void {
            var nextMessage:IBEMessage = new _backendMessageTypes[_nextMessageType]();
            // TODO: we should not need to copy things like this; if we can provide a
            // restricted view of the input stream, that will be enough
            var nextMessageBytes:ByteArray = new ByteArray();
            _dataStream.readBytes(nextMessageBytes, 0, _nextMessageLen);
            nextMessage.read(nextMessageBytes);
            dispatchEvent(new MessageEvent(nextMessage));
            _nextMessageType = -1;
            _nextMessageLen = -1;
            if (_dataStream.bytesAvailable >= 5) {
                readNextHeader();
            }
        }

        
    }
}