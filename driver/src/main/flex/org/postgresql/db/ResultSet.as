package org.postgresql.db {

    import org.postgresql.event.MetadataEvent;
    import org.postgresql.event.NoticeEvent;
    import org.postgresql.event.ResultSetEvent;

    public class ResultSet extends ResultBase implements IResultSet, IResultHandler {

        private var _columns:Array;
        private var _data:Array;

        public function ResultSet(stmt:IStatement) {
            super(stmt);
            _data = [];
        }
        
        public function handleColumns(cols:Array):void {
            _columns = cols;
            dispatchEvent(new MetadataEvent(MetadataEvent.METADATA, _columns));
        }

        public function handleRow(rowData:Array):void {
            var mappedRow:Object = {};
            // map rows from index-based to column-keyed
            for (var i:int = 0; i < rowData.length; i++) {
                var col:Column = _columns[i];
                mappedRow[col.name] = rowData[i];
            }
            _data.push(mappedRow);
        }

        public function handleBatch():void {
            // TODO: this will come into play with streaming
        }

        public function handleCompletion(command:String, rows:int=0, oid:int=-1):void {
            dispatchEvent(new ResultSetEvent(ResultSetEvent.RESULT, _data));
        }

        public function get columns():Array {
            return _columns;
        }
        
        public function get data():Array {
            return _data;
        }
        
        public function close():void {
            _data = [];
            _columns = [];
            // ? -- there may not be anything else to do for simple queries here
        }

    }
}