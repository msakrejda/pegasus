package org.postgresql.febe {

    import flash.events.Event;

    /**
     * An Event describing normal activity from a <code>MessageBroker</code>.
     *
     * @see org.postgresql.febe.MessageStream
     */
    public class MessageStreamEvent extends Event {

        /**
         * Incoming messages on a <code>MessageStream</code> may arrive in batches. When a
         * batch of messages has been processed, this event is dispatched. It allows for
         * processing of a set of messages and once and enables features like result set
         * streaming.
         *
         * @eventType batchComplete
         */
        public static const BATCH_COMPLETE:String = 'batchComplete';

        public function MessageStreamEvent(type:String) {
            super(type);
        }

    }
}