package org.postgresql.db {

    import org.postgresql.event.ResultEvent;
    
    public class Result extends ResultBase implements IResult, IResultHandler {

		private var _affectedRows:int;
		private var _oid:int;

    	public function Result(stmt:IStatement) {
    		super(stmt);
    	}

		public function handleColumns(cols:Array):void {
			// TODO: it's an error to submit a query through executeUpdate()--we can
			// either ignore the result, throw an error, or dispatch an error event.
		}

		public function handleRow(rowData:Array):void {
			// TODO: see handleColumns
		}

		public function handleBatch():void {
			// TODO: see handleColumns
		}

		public function handleCompletion(command:String, rows:int=0, oid:int=-1):void {
			// TODO: expose command?
			_affectedRows = rows;
			_oid = oid;
			dispatchEvent(new ResultEvent(ResultEvent.RESULT, rows, oid));
		}
    	
        public function get affectedRows():int {
        	return _affectedRows;
        }

        public function get insertOid():int {
        	return _oid;
        }
    }
}