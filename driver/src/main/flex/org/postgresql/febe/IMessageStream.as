package org.postgresql.febe {

    import flash.events.IEventDispatcher;
    import org.postgresql.febe.message.IFEMessage;

    /**
     * @eventType org.postgresql.febe.MessageStreamErrorEvent.ERROR
     */
    [Event(name="error", type="org.postgresql.febe.MessageStreamErrorEvent")]
    /**
     * @eventType org.postgresql.febe.MessageStreamEvent.BATCH_COMPLETE
     */
    [Event(name="batchComplete", type="org.postgresql.febe.MessageStreamEvent")]
    /**
     * @eventType org.postgresql.febe.MessageEvent.SENT
     */
    [Event(name="messageSent", type="org.postgresql.febe.MessageEvent")]
    /**
     * @eventType org.postgresql.febe.MessageEvent.RECEIVED
     */
    [Event(name="messageReceived", type="org.postgresql.febe.MessageEvent")]
    /**
     * The <code>IMessageStream</code> interface provides a message-level view of
     * a message-oriented application protocol (e.g., FEBE in the case of PostgreSQL).
     * A client sends <code>IFEMessage</code> to the server, and the server replies
     * with <code>IBEMessage</code>s.
     * <br/>
     * A message stream can be considered connected immediately, and stays connected
     * until the user calls <code>close()</code>. As with <code>IDataStream</code>, a
     * server never initiates a normal disconnect.
     *
     * @see org.postgresq.febe.message.IFEMessage
     * @see org.postgresq.febe.message.IBEMEssage
     */
    public interface IMessageStream extends IEventDispatcher {
        /**
         * Send message to the backend.
         *
         * @param message IFEMessage to send
         * @throws <code>Error</code> if message cannot be sent due to errors in the
         *  underlying connection
         */
        function send(message:IFEMessage):void;
        /**
         * Close underlying connection to the backend.
         */
        function close():void;
        /**
         * True if this stream is connected; false otherwise.
         */
        function get connected():Boolean;
    }
}