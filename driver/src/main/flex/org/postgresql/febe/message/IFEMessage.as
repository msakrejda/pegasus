package org.postgresql.febe.message {

    import org.postgresql.io.ICDataOutput;

    /**
     * A message sent by the client to the server.
     */
    public interface IFEMessage extends IMessage {
        /**
         * Write the message to the given ICDataOutput stream.
         * The serialization must include the entire message
         * as defined in the FEBE protocol, including the
         * message type byte and the message length.
         */
        function write(out:ICDataOutput):void;
    }
}