package org.postgresql.pegasus.functional {

    import org.postgresql.db.IColumn;
    import org.postgresql.db.event.QueryCompletionEvent;
    import org.postgresql.db.event.QueryResultEvent;
    import org.postgresql.db.EventResultHandler;
    import org.flexunit.async.Async;
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertNotNull;
    import org.postgresql.db.QueryToken;

    /**
     * @author maciek
     */
    public class ExtendedQueryTest extends ConnectedTestBase {

        private function runQuery(sql:String, args:Array, verifyFn:Function):void {
            var handler:EventResultHandler = new EventResultHandler();
            Async.proceedOnEvent(this, handler, QueryCompletionEvent.COMPLETE, 5000);

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

        [Test(async,timeout=5000)]
        public function testSelectInt():void {
            // TODO: this should handle smallint as well
            var verifyFn:Function = function(e:QueryResultEvent) : void {
                assertEquals(1, e.columns.length);
                assertEquals('arg', IColumn(e.columns[0]).name);

                assertEquals(1, e.data.length);
                assertEquals(0, e.data[0]['arg']);
            };

            var sql:String = "select $1::int as arg";
            runQuery(sql, [ 0 ], verifyFn);
        }


    }
}
