package org.postgresql.pegasus.functional {

    import org.flexunit.Assert;
    import flexunit.framework.Assert;
    import org.postgresql.util.DateUtil;
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

        private function runQuery(sql:String, verifyFn:Function):void {
            var handler:EventResultHandler = new EventResultHandler();
            Async.proceedOnEvent(this, handler, QueryCompletionEvent.COMPLETE, 1000);

            handler.addEventListener(QueryResultEvent.RESULT, verifyFn);
            // N.B.: this listener is executing with higher priority that the 'proceed' above
            handler.addEventListener(QueryCompletionEvent.COMPLETE, function(e:QueryCompletionEvent):void {
                    assertEquals(0, e.rows);
                    assertEquals('SELECT', e.tag);
            });

            var qt:QueryToken = connection.execute(sql, handler);
            assertNotNull(qt);
            assertEquals(qt.sql, sql);
        }

        [Test(async,timeout=1000)]
        public function testSelectText():void {
             var verifyFn:Function = function(e:QueryResultEvent) : void {
                assertEquals(3, e.columns.length);
                assertEquals('empty', IColumn(e.columns[0]).name);
                assertEquals('one_char', IColumn(e.columns[1]).name);
                assertEquals('text', IColumn(e.columns[2]).name);

                assertEquals(1, e.data.length);
                assertEquals('', e.data[0]['empty']);
                assertEquals('?', e.data[0]['one_char']);
                assertEquals('hello world', e.data[0]['text']);
            };

            var sql:String = "select ''::text as empty, '?'::text as one_char, 'hello world'::text as text";
            runQuery(sql, verifyFn);
        }

        [Test(async,timeout=1000)]
        public function testSelectInt():void {
            var verifyFn:Function = function(e:QueryResultEvent) : void {
                assertEquals(5, e.columns.length);
                assertEquals('neg_one', IColumn(e.columns[0]).name);
                assertEquals('zero', IColumn(e.columns[1]).name);
                assertEquals('one', IColumn(e.columns[2]).name);
                assertEquals('max_int', IColumn(e.columns[3]).name);
                assertEquals('min_int', IColumn(e.columns[4]).name);

                assertEquals(1, e.data.length);
                assertEquals(-1, e.data[0]['neg_one']);
                assertEquals(0, e.data[0]['zero']);
                assertEquals(1, e.data[0]['one']);
                assertEquals(int.MAX_VALUE, e.data[0]['max_int']);
                assertEquals(int.MIN_VALUE, e.data[0]['min_int']);
            };

            var sql:String = "select (-1)::int as neg_one, 0::int as zero, 1::int as one, (2^31-1)::int as max_int, (-(2^31))::int as min_int";
            runQuery(sql, verifyFn);
        }

        [Test(async,timeout=1000)]
        public function testSelectDate():void {
            var verifyFn:Function = function(e:QueryResultEvent) : void {
                assertEquals(3, e.columns.length);
                assertEquals('neg_inf', IColumn(e.columns[0]).name);
                assertEquals('epoch', IColumn(e.columns[1]).name);
                assertEquals('inf', IColumn(e.columns[2]).name);

                assertEquals(1, e.data.length);

                assertEquals(new Date(DateUtil.MIN_DATE_TICKS).time, e.data[0]['neg_inf'].time);
                assertEquals(new Date(1970, 0, 1).time, e.data[0]['epoch'].time);
                assertEquals(new Date(DateUtil.MAX_DATE_TICKS).time, e.data[0]['inf'].time);
            };

            // TODO: more dates
            var sql:String = "select '-infinity'::timestamptz as neg_inf, '1970-01-01 00:00:00'::timestamptz as epoch, 'infinity'::timestamptz as inf";
            runQuery(sql, verifyFn);
        }
    }
}
