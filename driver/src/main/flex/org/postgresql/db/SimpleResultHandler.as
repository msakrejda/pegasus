package org.postgresql.db {
    import org.postgresql.log.ILogger;
    import org.postgresql.log.Log;
    import org.postgresql.util.assert;
    

    public class SimpleResultHandler implements IResultHandler {

        private static const LOGGER:ILogger = Log.getLogger(SimpleResultHandler);
        
        private var _columns:Array;
        private var _data:Array;

        private var _onCompletion:Function;
        private var _onQueryResult:Function;

        public function SimpleResultHandler(onCompletion:Function, onQueryResult:Function=null) {
            if (!onCompletion) {
                throw new ArgumentError("Completion handler cannot be null");
            }
            _onQueryResult = onQueryResult;
            _onCompletion = onCompletion;
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
        
        public function handleCompletion(command:String, rows:int, oid:int):void {
            if (_columns) {
                onQueryResult(_columns, _data);
                _columns = null;
                _data = null;
            }
            onCompletion(command, rows);
        }

        protected function onQueryResult(columns:Array, data:Array):void {
            if (_onQueryResult) {
                _onQueryResult(columns, data);
            }
        }

        protected function onCompletion(command:String, rows:int):void {
            _onCompletion(command, rows);
        }

        public function dispose() : void {
            /* do nothing */
        }

    }
}