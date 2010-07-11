package org.postgresql.febe {

	import flash.events.Event;

	// TODO: this may need an associated or something 
	public class MessageStreamEvent extends Event {

		// TODO: add error message (and possibly for disconnected)
		/**
		 * An error has occurred in reading from the message stream. The message stream itself
		 * may still be in a valid state.
		 *
		 * @eventType error
		 */
		public static const ERROR:String = 'error';

		/**
		 * Dispatched when the connection to the server is lost.
		 *
		 * Note that this can happen in the course of normal operation,
		 * as a protocol error (that causes the server to drop the connection),
		 * or as a connectivity error.
		 *
		 * @eventType disconnected
		 */
		public static const DISCONNECTED:String = 'disconnected';

        /**
         * Depending on the nested IDataStream implementation, incoming messages may
         * arrive in batches. When a batch of messages has been processed, this event
         * is dispatched. It allows us to implement features like result set streaming
         * in an efficient and useful manner.
         *
         * @eventType batchComplete
         */  
        public static const BATCH_COMPLETE:String = "batchComplete";
		
		public function MessageStreamEvent(type:String) {
			super(type);
		}
		
	}
}