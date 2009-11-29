package org.postgresql.febe.message {

    import mx.utils.StringUtil;

    public class MessageError extends Error {

        public function MessageError(message:String, febeMsg:IMessage, id:int=0) {
            super(StringUtil.substitute("Invalid FEBE message {0}: {1}", febeMsg.type, message), id);
        }

    }
}