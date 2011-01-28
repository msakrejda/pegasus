package org.postgresql.db.event {

    import flash.events.Event;

    /**
     * Indicates the result of a <code>SELECT</code> query, or another query which
     * returns data.
     */
    public class QueryResultEvent extends Event {

        /**
         * A query result.
         *
         * @eventType queryResult
         */
        public static const RESULT:String = 'queryResult';

        private var _columns:Array;
        private var _data:Array;

        /**
         * Create a new query result event
         *
         * @param type type of event
         * @param columns <code>Array</code> of <code>IColumn</code> instances describing the query results
         * @param data <code>Array</code> of <code>Object</code>s containing the query results
         *
         * @private
         */
        public function QueryResultEvent(type:String, columns:Array, data:Array) {
            super(type, false, false);
            _data = data;
            _columns = columns;
        }

        /**
         * Columns describing the data.
         *
         * @see org.postgresql.db.ResultHandlerBase#columns
         */
        public function get columns():Array {
            return _columns;
        }

        /**
         * Query results.
         *
         * @see org.postgresql.db.ResultHandlerBase#columns
         */
        public function get data():Array {
            return _data;
        }
    }
}
