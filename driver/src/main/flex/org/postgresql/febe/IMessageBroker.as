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
     * The IMessageBroker interface provides a message-level view of the
     * PostgreSQL FEBE protocol.
     */
    public interface IMessageBroker extends IEventDispatcher {
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
         * True if this broker is connected; false otherwise.
         */
        function get connected():Boolean;
    }
}