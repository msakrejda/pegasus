package org.postgresql.db {

/**
 * An <code>IResultHandler</code> which invokes user-supplied callbacks when
 * query results are returned and on query completion.
 */
public class CallbackResultHandler extends ResultHandlerBase {

   private var _onCompletion:Function;
   private var _onQueryResult:Function;

   /**
    * Create a new <code>CallbackResultHandler</code> with specified callbacks.
    * The <code>onQueryCompletion</code> callback is required and should have the
    * following signature:
    * <pre>
    * function(command:String, affectedRows:int):void
    * </pre>
    * where <code>command</code> is the PotsgreSQL command tag for the given query
    * (e.g., <code>SELECT</code> or <code>INSERT</code>) and <code>affectedRows</code>
    * is the number of rows affected if an update was performed (note that this is
    * <em>not</em> the number of rows returned).
    * <br/>
    * The <code>onQueryResult</code> callback is optional and should have the
    * following signature:
    * <pre>
    * function(columns:Array, data:Array):void
    * </pre>
    * where <code>columns</code> is an array of <code>IColumn</code> objects defining the
    * fields returned and <code>data</code> is an array of <code>Object</code>s, each
    * representing a row with keys (property names) defined by the <code>IColumn</code>
    * objects and values corresponding to row values.
    * <br/>
    * If specified, the query result handler is invoked before the query completion
    * handler. Note that for a query with multiple statements, these may be invoked
    * multiple times.
    *
    * @param onCompletion query completion callback
    * @param onQueryResult query result callback
    * @see org.postgresql.db.IColumn
    */
   public function CallbackResultHandler(onCompletion:Function, onQueryResult:Function=null) {
      if (onCompletion == null) {
         throw new ArgumentError("Completion handler cannot be null");
      }
      _onQueryResult = onQueryResult;
      _onCompletion = onCompletion;
   }

   /**
    * @private
    */
   public override function doHandleCompletion(command:String, rows:int, oid:int, token:QueryToken):void {
      if (columns) {
         onQueryResult(columns, data);
      }
      onCompletion(command, rows);
   }

   /**
    * @private
    * Invokes the <code>onQueryResult</code> callback.
    */
   protected function onQueryResult(columns:Array, data:Array):void {
      if (_onQueryResult != null) {
         _onQueryResult(columns, data);
      }
   }

   /**
    * @private
    * Invokes the <code>onCompletion</code> callback.
    */
   protected function onCompletion(command:String, rows:int):void {
      _onCompletion(command, rows);
   }

}
}
