package org.postgresql.db {

    /**
     * An IResultHandler manages the results of query execution through a set of callbacks.
     * A query which returns data will typically have the following methods involved (in
     * this order):
     * <ol>
     *   <li>handleColumns</li>
     *   <li>handleRow (zero or more times)</li>
     *   <li>handleCompletion</li>
     *   <li>dispose</li>
     * </ol>
     * A query which does not return data will only have the last two invoked. A query
     * which encounters a server-side error will only have <code>dispose</code> invoked.
     * A query which encounters an error in decoding will not have <code>handleCompletion</code>
     * invoked, and may miss one or more <code>handleRow</code> calls.
     */
    public interface IResultHandler {
        /**
         * Handle the columns
         * @param columns Array of IColumn objects describing the data.
         */
        function handleColumns(columns:Array):void;
        /**
         * @param rowData Array of column values corresponding to a single row of results
         */
        function handleRow(rowData:Array):void;
        /**
         * @param command the PostgreSQL tag specifying the command that just completed, e.g.
         *      <code>SELECT</code> or <code>INSERT</code>
         * @param rows the number of rows affected, or -1 if no rows were affected (e.g., a DDL command)
         * @param oid on INSERT, the oid of the inserted row if the target table has oids and
         *                 the insert is a single row, 0 on other INSERT, -1 otherwise
         */
        function handleCompletion(command:String, rows:int, oid:int):void;
        /**
         * Clean up resources associated with this result handler. Note that this method
         * is invoked after either successful completion or an error. In either case,
         * the handler should clean up.
         */
        function dispose():void;
    }
}