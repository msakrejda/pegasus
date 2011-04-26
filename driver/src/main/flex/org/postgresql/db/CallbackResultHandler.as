package org.postgresql.db {
    import org.postgresql.log.ILogger;
    import org.postgresql.log.Log;

    public class CallbackResultHandler extends ResultHandlerBase {

        private static const LOGGER:ILogger = Log.getLogger(CallbackResultHandler);

        private var _onCompletion:Function;
        private var _onQueryResult:Function;

        public function CallbackResultHandler(onCompletion:Function, onQueryResult:Function=null) {
            if (!onCompletion) {
                throw new ArgumentError("Completion handler cannot be null");
            }
            _onQueryResult = onQueryResult;
            _onCompletion = onCompletion;
        }

        public override function doHandleCompletion(command:String, rows:int, oid:int):void {
            if (columns) {
                onQueryResult(columns, data);
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

    }
}