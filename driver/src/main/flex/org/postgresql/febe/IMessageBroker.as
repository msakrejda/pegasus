package org.postgresql.febe {

	import flash.events.IEventDispatcher;
	import org.postgresql.febe.message.IFEMessage;

	/**
	 * @eventType org.postgresql.febe.MessageEvent.ERROR
	 */
	[Event(name="error", type="org.postgresql.febe.MessageStreamEvent")]
	/**
	 * @eventType org.postgresql.febe.MessageStreamEvent.BATCH_COMPLETE
	 */	
	[Event(name="batchComplete", type="org.postgresql.febe.MessageStreamEvent")]

	/**
	 * @eventType org.postgresql.febe.MessageStreamEvent.DISCONNECTED
	 */
	[Event(name="disconnected", type="org.postgresql.febe.MessageStreamEvent")]
	// TODO: provide a way to distinguish the three types of connection drops.
	// For the first case, we expect the disconnect, and for the second, we'll
	// typically get error messages from the server before the connection drops,
	// but it would still be nice to deal more elegantly with this at the broker
	// level (e.g., propagate connectivity errors).
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
		 * Send given message to the backend.
		 *
		 * @param message IFEMessage to send
		 * @throws Error if message cannot be sent (typically due to problems
		 * 		in underlying connection)
		 */
		function send(message:IFEMessage):void;
		/**
		 * Close underlying connection to the backend.
		 *
		 * TODO: what happens if called multiple times? Errors?
		 */
		function close():void;
	}
}