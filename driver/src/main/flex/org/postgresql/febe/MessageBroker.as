package org.postgresql.febe {

    import flash.events.EventDispatcher;
    
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
    import org.postgresql.io.DataStreamErrorEvent;
    import org.postgresql.io.DataStreamEvent;
    import org.postgresql.io.IDataStream;
    import org.postgresql.log.ILogger;
    import org.postgresql.log.Log;

    public class MessageBroker extends EventDispatcher implements IMessageBroker {

        private static const LOGGER:ILogger = Log.getLogger(MessageBroker); 

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
        };

        private var _dataStream:IDataStream;
        private var _onDisconnected:Function;

        private var _nextMessageType:int;
        private var _nextMessageLen:int;
        
        public function MessageBroker(stream:IDataStream) {
            _dataStream = stream;
            _dataStream.addEventListener(DataStreamEvent.PROGRESS, handleStreamData);
            _dataStream.addEventListener(DataStreamErrorEvent.ERROR, handleError);

            _nextMessageType = -1;
            _nextMessageLen = -1;
        }

        private function handleStreamData(e:DataStreamEvent):void {
            while (_dataStream.connected &&
                   (_nextMessageLen == -1 && _dataStream.bytesAvailable >= 5 /* len + type */) ||
                   (_nextMessageLen != -1 && _dataStream.bytesAvailable >= _nextMessageLen)) {
                if (_nextMessageLen == -1) {
                    _nextMessageType = _dataStream.readByte();
                    // FEBE encodes the message length as including the size
                    // of the length field itself. This does not work well for
                    // our purposes (it would make a number of things more confusing
                    // than necessary), so we subtract the size of the length field.
                    _nextMessageLen = _dataStream.readInt() - 4;
                } else {
                    // TODO: We should not have to copy the message to its own array: we
                    // should wrap the stream in something that sets an arbitrary hard limit
                    // to the number of bytes this particular message can read.
                    var messageBytes:ByteDataStream = new ByteDataStream();
                    _dataStream.readBytes(messageBytes, 0, _nextMessageLen);
                    var nextTypeCode:String = String.fromCharCode(_nextMessageType);
                    var nextMessageClass:Class = backendMessageTypes[nextTypeCode];
                    if (!nextMessageClass) {
                        LOGGER.error("No message class found for message type {0}", nextTypeCode);
                        dispatchEvent(new MessageStreamEvent(MessageStreamEvent.ERROR));
                    } else {
                        try {
                            var nextMessage:IBEMessage = new nextMessageClass();
                            nextMessage.read(messageBytes);
                            LOGGER.debug('<= {0}', nextMessage);
                            dispatchEvent(new MessageEvent(MessageEvent.RECEIVED, nextMessage));
                        } catch (e:Error) {
                            dispatchEvent(new MessageStreamEvent(MessageStreamEvent.ERROR));
                        } finally {
                            // TODO: we should probably try sync in the catch or something: it's rather
                            // optimistic to assume that this finally clause will work for the failure case
                            _nextMessageType = -1;
                            _nextMessageLen = -1;
                        }
                    }
                }
            }
            dispatchEvent(new MessageStreamEvent(MessageStreamEvent.BATCH_COMPLETE));
        }

        private function handleError(e:DataStreamEvent):void {
        	// TODO: review this event
            dispatchEvent(new MessageStreamEvent(MessageStreamEvent.DISCONNECTED));
        }

        public function send(message:IFEMessage):void {
            LOGGER.debug('=> {0}', message);
            // TODO: handle write errors here (or in FEBEConnection)
            message.write(_dataStream);
            dispatchEvent(new MessageEvent(MessageEvent.SENT, message));
        }

        public function close():void {
            _dataStream.close();
        }

    }
}
