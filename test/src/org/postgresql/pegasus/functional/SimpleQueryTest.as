package org.postgresql.pegasus.functional {

    import org.flexunit.asserts.assertTrue;
    import org.flexunit.asserts.assertNull;
    import org.hamcrest.assertThatBoolean;
    import org.flexunit.asserts.fail;
    import org.postgresql.util.Assert;
    import org.postgresql.util.NumberUtil;
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
        public function testSelectFloat():void {
            var verifyFn:Function = function(e:QueryResultEvent) : void {
                assertEquals(2, e.columns.length);
                assertEquals('float', IColumn(e.columns[0]).name);
                assertEquals('double', IColumn(e.columns[1]).name);

                assertEquals(11, e.data.length);

                assertWithin(-Infinity, e.data[0]['float'], 0);
                assertWithin(-Infinity, e.data[0]['double'], 0);
                assertWithin(-NumberUtil.FLOAT_MAX_VALUE, e.data[1]['float'], 1e34);
                assertWithin(-Number.MAX_VALUE, e.data[1]['double'], 1e300);
                assertWithin(-1, e.data[2]['float']);
                assertWithin(-1, e.data[2]['double']);
                assertWithin(-NumberUtil.FLOAT_MIN_NORMAL, e.data[3]['float'], NumberUtil.FLOAT_MIN_NORMAL);
                assertWithin(-NumberUtil.DOUBLE_MIN_NORMAL, e.data[3]['double'], NumberUtil.DOUBLE_MIN_NORMAL);
                // N.B.: We don't technically get a negative zero here, but 0 == -0 for as3; we leave
                // the test regardless since this should also work
                assertWithin(-0, e.data[4]['float'], 0);
                assertWithin(-0, e.data[4]['double'], 0);
                assertWithin(0, e.data[5]['float'], 0);
                assertWithin(0, e.data[5]['double'], 0);
                assertWithin(NumberUtil.FLOAT_MIN_NORMAL, e.data[6]['float'], NumberUtil.FLOAT_MIN_NORMAL);
                assertWithin(NumberUtil.DOUBLE_MIN_NORMAL, e.data[6]['double'], NumberUtil.DOUBLE_MIN_NORMAL);
                assertWithin(1, e.data[7]['float']);
                assertWithin(1, e.data[7]['double']);
                assertWithin(NumberUtil.FLOAT_MAX_VALUE, e.data[8]['float'], 1e34);
                assertWithin(Number.MAX_VALUE, e.data[8]['double'], 1e300);
                assertWithin(Infinity, e.data[9]['float'], 0);
                assertWithin(Infinity, e.data[9]['double'], 0);
                assertWithin(NaN, e.data[10]['float'], 0);
                assertWithin(NaN, e.data[10]['double'], 0);
            };

            var sql:String = "select float, double from (values" +
                    "('-infinity'::float4, '-infinity'::float8)," +
                    "((-" + NumberUtil.FLOAT_MAX_VALUE.toPrecision(20) + ")::float4, (-" + Number.MAX_VALUE.toPrecision(20) + ")::float8)," +
                    "((-1)::float4, (-1)::float8)," +
                    "((-" + NumberUtil.FLOAT_MIN_NORMAL.toPrecision(20) + ")::float4, (-" + NumberUtil.DOUBLE_MIN_NORMAL.toPrecision(20) + ")::float8)," +
                    "((-0)::float4, (-0)::float8)," +
                    "(0::float4, 0::float8)," +
                    "((" + NumberUtil.FLOAT_MIN_NORMAL.toPrecision(20) + ")::float4, (" + NumberUtil.DOUBLE_MIN_NORMAL.toPrecision(20) + ")::float8)," +
                    "(1::float4, 1::float8)," +
                    "((" + NumberUtil.FLOAT_MAX_VALUE.toPrecision(20) + ")::float4, (" + Number.MAX_VALUE.toPrecision(20) + ")::float8)," +
                    "('infinity'::float4, 'infinity'::float8)," +
                    "('NaN'::float4, 'NaN'::float8)" +
                ") as vals(float, double)";
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

                assertDatesEqual(new Date(DateUtil.MIN_DATE_TICKS), e.data[0]['neg_inf']);
                assertDatesEqual(new Date(1970, 0, 1), e.data[0]['epoch']);
                assertDatesEqual(new Date(DateUtil.MAX_DATE_TICKS), e.data[0]['inf']);
            };

            // TODO: more dates
            var sql:String = "select '-infinity'::timestamptz as neg_inf, '1970-01-01 00:00:00'::timestamptz as epoch, 'infinity'::timestamptz as inf";
            runQuery(sql, verifyFn);
        }

        // TODO: these should be pulled out as more general, but the way asserts work
        // in flexunit, this is a little tricky
        private static function assertDatesEqual(expected:Date, actual:Date):void {
            if (expected == null) {
                assertNull("Expected null; got " + actual, false);
            } else {
                assertEquals("Expected " + expected + "; got " + actual, expected.time, actual.time);
            }
        }

        private static function assertWithin(expected:Number, actual:Number, tolerance:Number=1e-10):void {
            if (isFinite(expected)) {
                assertTrue("Expected " + expected.toPrecision(20) + " +/-" + tolerance + "; got " + actual.toPrecision(20) +
                    " (an error of " + Math.abs(expected - actual) + ")", Math.abs(expected - actual) <= tolerance);
            } else {
                assertTrue("Expected " + expected.toPrecision(20) + "; got " + actual.toPrecision(20),
                    !isFinite(actual) && isNaN(expected) == isNaN(actual) && expected > 0 == actual > 0);

            }
        }
    }
}
