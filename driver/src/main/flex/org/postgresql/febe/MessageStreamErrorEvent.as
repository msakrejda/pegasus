package org.postgresql.febe {

    import flash.events.ErrorEvent;

    /**
     * An Event describing an error in an <code>IMessageBroker</code>.
     *
     * @see org.postgresql.io.IDataStream
     */
    public class MessageStreamErrorEvent extends ErrorEvent {

        /**
         * An error has occurred in reading from the message stream. The message stream itself
         * may still be in a valid state.
         *
         * @eventType error
         */
        public static const ERROR:String = 'error';

        public function MessageStreamErrorEvent(type:String, text:String="") {
            super(type, false, false, text);
        }

    }
}