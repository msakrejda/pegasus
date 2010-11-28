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
    public class SimpleQueryTest extends ConnectedTestBase {

        [Test(async,timeout=1000)]
        public function testSelectText():void {
            var handler:EventResultHandler = new EventResultHandler();
            Async.proceedOnEvent(this, handler, QueryCompletionEvent.COMPLETE, 1000);

			handler.addEventListener(QueryResultEvent.RESULT, function(e:QueryResultEvent) : void {
                    // Note that rowCount for a SELECT does *not* reflect the number of affected rows
                    assertEquals(3, e.columns.length);
                    assertEquals('empty', IColumn(e.columns[0]).name);
                    assertEquals('one_char', IColumn(e.columns[1]).name);
					assertEquals('text', IColumn(e.columns[2]).name);

                    assertEquals(1, e.data.length);
                    assertEquals('', e.data[0]['empty']);
                    assertEquals('?', e.data[0]['one_char']);
                    assertEquals('hello world', e.data[0]['text']);
                });
            // N.B.: this listener is executing with higher priority that the 'proceed' above
            handler.addEventListener(QueryCompletionEvent.COMPLETE, function(e:QueryCompletionEvent):void {
                    assertEquals(0, e.rows);
                    assertEquals('SELECT', e.tag);
            });

            var sql:String = "select ''::text as empty, '?'::text as one_char, 'hello world'::text as text";
            var qt:QueryToken = connection.execute(sql, handler);
            assertNotNull(qt);
            assertEquals(qt.sql, sql);
        }
    }
}
