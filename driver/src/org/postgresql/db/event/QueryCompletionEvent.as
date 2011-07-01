package org.postgresql.db.event {

    import flash.events.Event;

    /**
     * Indicates the completion of a query.
     */
    public class QueryCompletionEvent extends Event {

        /**
         * A query completion.
         *
         * @eventType queryComplete
         */
        public static const COMPLETE:String = 'queryComplete';

        private var _tag:String;
        private var _rows:int;
        private var _oid:int;

        /**
         * Create a query completion event.
         *
         * @param type type of event
         * @param tag query completion tag
         * @param rows number of rows affected by this query, if applicable
         * @param oid oid of inserted row, if applicable
         *
         * @private
         */
        public function QueryCompletionEvent(type:String, tag:String, rows:int, oid:int) {
            super(type, false, false);
            _tag = tag;
            _rows = rows;
            _oid = oid;
        }

        /**
         * Number of rows affected by query. Note that this is <em>not</em> the number of rows returned
         * by a <code>SELECT</code>; it corresponds to changes by <code>INSERT</code>, <code>UPDATE</code>,
         * and <code>DELETE</code> queries.
         */
        public function get rows():int {
            return _rows;
        }

        /**
         * If the query was an <code>INSERT</code> of a single row, and if the target table has oids,
         * this contains the oid of the newly-inserted row. Otherwise, it is zero.
         */
        public function get oid():int {
            return _oid;
        }

        /**
         * The query completion tag (e.g., <code>SELECT</code> or <code>CREATE TABLE</code>)
         */
        public function get tag():String {
            return _tag;
        }
    }
}
