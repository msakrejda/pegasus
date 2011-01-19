package org.postgresql.db {

    /**
     * Class to identify a particular query execution.
     * <br/>
     * Note that while this can be managed through the query SQL in many situations, that
     * approach fails when the same query is submitted concurrently several times. Currently,
     * <code>QueryToken</code>s are only used to cancel queries.
     */
    public class QueryToken {

        private var _sql:String;

        /**
         * @private
         */
        public function QueryToken(sql:String) {
            _sql = sql;
        }

        /**
         * The SQL of the associated query
         */
        public function get sql():String {
            return _sql;
        }

    }
}