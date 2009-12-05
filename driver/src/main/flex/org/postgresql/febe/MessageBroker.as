package org.postgresql.febe {

    import flash.events.Event;
    import flash.events.EventDispatcher;
    
    import mx.logging.ILogger;
    import mx.logging.Log;
    
    import org.postgresql.febe.message.AuthenticationRequest;
    import org.postgresql.febe.message.BackendKeyData;
    import org.postgresql.febe.message.Bind;
    import org.postgresql.febe.message.CancelRequest;
    import org.postgresql.febe.message.CommandComplete;
    import org.postgresql.febe.message.DataRow;
    import org.postgresql.febe.message.Describe;
    import org.postgresql.febe.message.EmptyQueryResponse;
    import org.postgresql.febe.message.ErrorResponse;
    import org.postgresql.febe.message.Flush;
    import org.postgresql.febe.message.IBEMessage;
    import org.postgresql.febe.message.IFEMessage;
    import org.postgresql.febe.message.NoData;
    import org.postgresql.febe.message.NoticeResponse;
    import org.postgresql.febe.message.ParameterStatus;
    import org.postgresql.febe.message.ParseComplete;
    import org.postgresql.febe.message.PasswordMessage;
    import org.postgresql.febe.message.Query;
    import org.postgresql.febe.message.ReadyForQuery;
    import org.postgresql.febe.message.RowDescription;
    import org.postgresql.febe.message.StartupMessage;
    import org.postgresql.febe.message.Sync;
    import org.postgresql.febe.message.Terminate;
    import org.postgresql.io.ByteDataStream;
    import org.postgresql.io.IDataStream;
    import org.postgresql.io.SocketDataStream;

    public class MessageBroker {

        private static const LOGGER:ILogger = Log.getLogger("org.postgresql.febe.MessageBroker");

        public static const backendMessageTypes:Object = {
            'R': AuthenticationRequest,
            'K': BackendKeyData,
            'B': Bind,
            'C': CommandComplete,
            'D': DataRow,
            'I': EmptyQueryResponse,
            'E': ErrorResponse,
            'n': NoData,
            'N': NoticeResponse,
            'S': ParameterStatus,
            '1': ParseComplete,
            'Z': ReadyForQuery,
            'T': RowDescription
        }

        private var _dataStream:IDataStream;

        private var _nextMessageType:int;
        private var _nextMessageLen:int;

        private var _dispatcher:EventDispatcher;

        public function MessageBroker(stream:IDataStream) {
            _dataStream = stream;
            _dataStream.addEventListener(SocketDataStream.DATA_AVAILABLE, handleSocketData);

            _nextMessageType = -1;
            _nextMessageLen = -1;

            _dispatcher = new EventDispatcher();
        }

        private function handleSocketData(e:Event):void {
        	while ((_nextMessageLen == -1 && _dataStream.bytesAvailable >= 5) ||
        	       (_nextMessageLen != -1 && _dataStream.bytesAvailable >= _nextMessageLen)) {
                if (_nextMessageLen == -1) {
                	_nextMessageType = _dataStream.readByte();
                    // FEBE encodes the message length as including the size
                    // of the length field itself. This does not work well for
                    // our purposes--we subtract the size of the length field.
                	_nextMessageLen = _dataStream.readInt() - 4;
                } else {
		            // TODO: We should not have to copy the message to its own array: we
		            // should wrap the stream in something that sets a 'dummy' limit to
		            // the number of bytes this particular message can read.
		            var messageBytes:ByteDataStream = new ByteDataStream();
		            _dataStream.readBytes(messageBytes, 0, _nextMessageLen);
		
		            var nextMessage:IBEMessage = new backendMessageTypes[String.fromCharCode(_nextMessageType)]();
		            nextMessage.read(messageBytes);
		            dispatch(nextMessage);
		            _nextMessageType = -1;
		            _nextMessageLen = -1;
                }
	        }
        }

        public function send(message:IFEMessage):void {
            LOGGER.debug('=> {0}', message);
            message.write(_dataStream);
        }

        private function dispatch(message:IBEMessage):void {
            LOGGER.debug('<= {0}', message);
            _dispatcher.dispatchEvent(new MessageEvent(message));
        }

        public function addMessageListener(type:Class, handler:Function):void {
            _dispatcher.addEventListener(String(type), handler);
        }

        public function removeMessageListener(type:Class, handler:Function):void {
            _dispatcher.removeEventListener(String(type), handler);
        }

    }
}
