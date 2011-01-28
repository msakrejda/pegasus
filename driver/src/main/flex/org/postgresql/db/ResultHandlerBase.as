package org.postgresql.db {

    import org.postgresql.util.AbstractMethodError;
    import org.postgresql.util.assert;
    import org.postgresql.log.ILogger;
    import org.postgresql.log.Log;

    /**
     * A handler that can be used as the base for most simple result handlers.
     * This handler simply stores the column metadata passed in. When each row
     * is passed in, a map of column names to data values is created and appended
     * to the results. Query completion behavior must be overridden by subclasses.
     */
    public /* abstract */ class ResultHandlerBase implements IResultHandler {

        private static const LOGGER:ILogger = Log.getLogger(ResultHandlerBase);

        /**
         * Internal variable to hold the query metadata.
         */
        protected var _columns:Array;

        /**
         * Internal variable to hold query results.
         */
        protected var _data:Array;

        /**
         * Metadata describing this query.
         *
         * @see org.postgresql.db.IColumn
         */
        public function get columns():Array {
            return _columns;
        }

        /**
         * Query results. For each row in the results, this <code>Array</code> contains an <code>Object</code>
         * mapping the column names (as given by the <code>columns</code> metadata) to the values for that particular
         * row. PostgreSQL <code>NULL</code>s are mapped to the ActionScript <code>null</code> value.
         * <br/>
         * Note that when multiple columns have the same name, only a single arbitrary column (possibly even a different
         * column per row). It goes without saying that if such queries are required, a different <code>IResultHandler</code>
         * implementation is recommended.
         */
        public function get data():Array {
            return _data;
        }

        /**
         * This implementation simply stores the columns passed in and clears out the <code>_data</code> array.
         */
        public function handleColumns(columns:Array):void {
            _columns = columns;
            _data = [];
        }

        /**
         * This implementation maps the column names to the values for the given row
         * and adds this to the <code>_data</code> array.
         */
        public function handleRow(rowData:Array):void {
            assert("Received data before metadata", _data);
            if (rowData.length != _columns.length) {
                LOGGER.error("Unexpected row data: got {0} fields, expected {1}; skipping", rowData.length, _columns.length);
                return;
            }
            var row:Object = {};
            // Re-map values based on column names. This is problematic when multiple
            // columns with the same name are present, but that rarely happens in
            // practice so this is a reasonable default implementation.
            for (var i:int = 0; i < rowData.length; i++) {
                var col:IColumn = _columns[i];
                var data:Object = rowData[i];
                row[col.name] = data;
            }
            _data.push(row);
        }

        /**
         * This method is abstract and must be overridden by subsclasses
         */
        public /* abstract */ function handleCompletion(command:String, rows:int, oid:int):void {
            throw new AbstractMethodError();
        }

        /**
         * This method simply clears the handler's references to both <code>_columns</code> and <code>_data</code>.
         */
        public function dispose() : void {
            _columns = null;
            _data = null;
        }
    }
}
