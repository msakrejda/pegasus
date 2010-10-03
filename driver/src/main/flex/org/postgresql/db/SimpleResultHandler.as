package org.postgresql.db {
	import org.postgresql.log.ILogger;
	import org.postgresql.log.Log;
	import org.postgresql.util.assert;
	

	public class SimpleResultHandler implements IResultHandler {

		private static const LOGGER:ILogger = Log.getLogger(SimpleResultHandler);
		
		private var _columns:Array;
		private var _data:Array;

		private var _queryResult:Function;
		private var _updateResult:Function;
		private var _errorResult:Function;

		public function SimpleResultHandler(queryResult:Function, updateResult:Function, errorResult:Function=null) {
			if (queryResult == null || updateResult == null) {
				throw new ArgumentError("Query and result handlers cannot be null");
			}
			_queryResult = queryResult;
			_updateResult = updateResult;
			_errorResult = errorResult;
		}

		public function handleNotice(fields:Object):void {
			LOGGER.info("Query notice:");
			for (var key:String in fields) {
				LOGGER.info("\t{0}: {1}", key, fields[key]);
			}
		}
		
		public function handleError(fields:Object):void {
			if (_errorResult != null) {
				_errorResult(fields);
			} else {
				onError(fields);
			}
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
			} else {
				onUpdateResult(command, rows);
			}
		}

		protected function onQueryResult(columns:Array, data:Array):void {
			_queryResult(columns, data);
		}

		protected function onUpdateResult(command:String, rows:int):void {
			_updateResult(command, rows);
		}

		protected function onError(fields:Object):void {
			LOGGER.error("Query error:");
			for (var key:String in fields) {
				LOGGER.error("{0}: {1}", key, fields[key]);
			}
		}

	}
}