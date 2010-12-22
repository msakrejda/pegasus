package org.postgresql.io {

    import flash.events.Event;

    /**
     * An Event describing normal activity on a <code>IDataStream</code>.
     *
     * @see org.postgresql.io.IDataStream
     */
    public class DataStreamEvent extends Event {

        /**
         * New data is available to be read from this <code>IDataStream</code>.
         * Inspect the dispatching stream itself (i.e., the <code>target</code>)
         * to find the incoming data.
         *
         * @eventType progress
         */
        public static const PROGRESS:String = 'progress';

        /**
         * @inheritDoc
         */
        public function DataStreamEvent(type:String) {
            super(type);
        }

    }
}