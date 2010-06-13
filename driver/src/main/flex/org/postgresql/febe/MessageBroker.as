package org.postgresql.febe {

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    
    import org.postgresql.febe.message.AuthenticationRequest;
    import org.postgresql.febe.message.BackendKeyData;
    import org.postgresql.febe.message.Bind;
    import org.postgresql.febe.message.CloseComplete;
    import org.postgresql.febe.message.CommandComplete;
    import org.postgresql.febe.message.DataRow;
    import org.postgresql.febe.message.EmptyQueryResponse;
    import org.postgresql.febe.message.ErrorResponse;
    import org.postgresql.febe.message.IBEMessage;
    import org.postgresql.febe.message.IFEMessage;
    import org.postgresql.febe.message.NoData;
    import org.postgresql.febe.message.NoticeResponse;
    import org.postgresql.febe.message.ParameterDescription;
    import org.postgresql.febe.message.ParameterStatus;
    import org.postgresql.febe.message.ParseComplete;
    import org.postgresql.febe.message.PortalSuspended;
    import org.postgresql.febe.message.ReadyForQuery;
    import org.postgresql.febe.message.RowDescription;
    import org.postgresql.io.ByteDataStream;
    import org.postgresql.io.IDataStream;
    import org.postgresql.io.SocketDataStream;
    import org.postgresql.log.ILogger;
    import org.postgresql.log.Log;

    public class MessageBroker extends EventDispatcher {

        private static const LOGGER:ILogger = Log.getLogger(MessageBroker); 

        /**
         * Depending on the nested IDataStream implementation, incoming messages may
         * arrive in batches. When a batch of messages has been processed, this event
         * is dispatched. It allows us to implement features like result set streaming
         * in an efficient and useful manner.
         */  
        public static const BATCH_COMPLETE:String = "batchComplete";

        // Commented-out messages are part of the protocol but unimplemented. COPY
        // will probably be implemented at some point; the function call (fastpath)
        // subprotocol probably will not be
        public static const backendMessageTypes:Object = {
            'R': AuthenticationRequest,
            'K': BackendKeyData,
            'B': Bind,
            'C': CommandComplete,
          /*'d': CopyData,
            'c': CopyDone,
            'G': CopyInResponse,
            'H': CopyOutResponse */
            '3': CloseComplete,
            'D': DataRow,
            'I': EmptyQueryResponse,
            'E': ErrorResponse,
          /*'V': FunctionCallResponse */ 
            'n': NoData,
            'N': NoticeResponse,
            't': ParameterDescription,
            'S': ParameterStatus,
            '1': ParseComplete,
            's': PortalSuspended,
            'Z': ReadyForQuery,
            'T': RowDescription
        }

        private var _dataStream:IDataStream;

        private var _nextMessageType:int;
        private var _nextMessageLen:int;

        private var _msgListeners:Dictionary;
        
        public function MessageBroker(stream:IDataStream) {
            _dataStream = stream;
            _dataStream.addEventListener(SocketDataStream.DATA_AVAILABLE, handleSocketData);

            _nextMessageType = -1;
            _nextMessageLen = -1;

            _msgListeners = new Dictionary();
        }

        private function handleSocketData(e:Event):void {
        	while (_dataStream.connected &&
        		   (_nextMessageLen == -1 && _dataStream.bytesAvailable >= 5) ||
        	       (_nextMessageLen != -1 && _dataStream.bytesAvailable >= _nextMessageLen)) {
                if (_nextMessageLen == -1) {
                	_nextMessageType = _dataStream.readByte();
                    // FEBE encodes the message length as including the size
                    // of the length field itself. This does not work well for
                    // our purposes--we subtract the size of the length field.
                	_nextMessageLen = _dataStream.readInt() - 4;
                } else {
		            // TODO: We should not have to copy the message to its own array: we
		            // should wrap the stream in something that sets an arbitrary hard limit
		            // to the number of bytes this particular message can read.
		            var messageBytes:ByteDataStream = new ByteDataStream();
		            _dataStream.readBytes(messageBytes, 0, _nextMessageLen);
		
		            var nextMessage:IBEMessage = new backendMessageTypes[String.fromCharCode(_nextMessageType)]();
		            nextMessage.read(messageBytes);
		            dispatch(nextMessage);
		            _nextMessageType = -1;
		            _nextMessageLen = -1;
                }
	        }
	        dispatchEvent(new Event(BATCH_COMPLETE));
        }

        public function send(message:IFEMessage):void {
        	// TODO: move the logging out to remove Flex dependencies here
            LOGGER.debug('=> {0}', message);
            message.write(_dataStream);
            dispatchEvent(new MessageEvent(MessageEvent.SENT, message));
        }

        private function dispatch(message:IBEMessage):void {
            LOGGER.debug('<= {0}', message);
            var listener:Function = _msgListeners[Object(message).constructor];
            if (listener != null) {
            	listener(message);
                dispatchEvent(new MessageEvent(MessageEvent.RECEIVED, message));
            } else {
            	dispatchEvent(new MessageEvent(MessageEvent.DROPPED, message));
            }
        }
        
        public function setMessageListener(msg:Class, callback:Function):void {
       		_msgListeners[msg] = callback;
        }

        public function clearMessageListener(msg:Class):void {
        	delete _msgListeners[msg];
        }

        public function close():void {
        	_dataStream.close();
        }

    }
}
