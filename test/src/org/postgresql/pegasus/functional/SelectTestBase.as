package org.postgresql.pegasus.functional {
    import org.flexunit.async.Async;
    import org.flexunit.asserts.assertNotNull;
    import org.postgresql.db.QueryToken;
    import org.flexunit.asserts.assertEquals;
    import org.postgresql.db.event.QueryResultEvent;
    import org.postgresql.db.event.QueryCompletionEvent;
    import org.postgresql.db.EventResultHandler;

    public /* asbtract */ class SelectTestBase extends ConnectedTestBase {

        protected function runQuery(verifyFn:Function, sql:String, args:Array=null):void {
            var handler:EventResultHandler = new EventResultHandler();
            Async.proceedOnEvent(this, handler, QueryCompletionEvent.COMPLETE, 1000);

            handler.addEventListener(QueryResultEvent.RESULT, verifyFn);
            // N.B.: this listener is executing with higher priority that the 'proceed' above
            handler.addEventListener(QueryCompletionEvent.COMPLETE, function(e:QueryCompletionEvent):void {
                    assertEquals(0, e.rows);
                    assertEquals('SELECT', e.tag);
            });

            var qt:QueryToken = connection.execute(handler, sql, args);
            assertNotNull(qt);
            assertEquals(qt.sql, sql);
        }
    }
}
