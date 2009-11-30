package org.postgresql.febe.message {

    import mx.utils.StringUtil;
    import org.postgresql.febe.ProtocolError;

    public class MessageError extends ProtocolError {

        public function MessageError(message:String, febeMsg:IMessage, id:int=0) {
            super(StringUtil.substitute("Invalid FEBE {0} message: {1}", febeMsg.type, message), id);
        }

    }
}