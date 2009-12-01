package org.postgresql.febe.message {

    import org.postgresql.io.ICDataInput;

    /**
     * A message sent by the server to the client.
     */
    public interface IBEMessage extends IMessage {
        /**
         * Read the message payload. This does not include the
         * one-byte message type header, nor the message length.
         */
        function read(input:ICDataInput):void;
    }
}