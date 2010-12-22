package org.postgresql.db {

    import org.postgresql.util.AbstractMethodError;
    import org.postgresql.util.assert;
    import org.postgresql.log.ILogger;
    import org.postgresql.log.Log;

    /**
     * A simple handler
     */
    public class ResultHandlerBase implements IResultHandler {

        private static const LOGGER:ILogger = Log.getLogger(ResultHandlerBase);

        private var _columns:Array;
        private var _data:Array;
        public function get columns():Array {
            return _columns;
        }

        public function get data():Array {
            return _data;
        }

        public function handleColumns(columns:Array):void {
            _columns = columns;
            _data = [];
        }

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

        public /* abstract */ function handleCompletion(command:String, rows:int, oid:int):void {
            throw new AbstractMethodError();
        }

        public function dispose() : void {
            _columns = null;
            _data = null;
        }
    }
}
