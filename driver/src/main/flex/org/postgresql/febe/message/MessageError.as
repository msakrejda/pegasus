package org.postgresql.febe.message {

    import org.postgresql.ProtocolError;
    import org.postgresql.util.format;

    public class MessageError extends ProtocolError {

        public function MessageError(message:String, febeMsg:IMessage, id:int=0) {
            super(format("Invalid FEBE {0} message: {1}", febeMsg.type, message), id);
        }

    }
}