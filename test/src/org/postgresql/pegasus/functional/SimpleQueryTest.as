package org.postgresql.pegasus.functional {
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import org.flexunit.async.Async;
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertNotNull;
    import org.postgresql.db.SimpleResultHandler;
    import org.postgresql.db.QueryToken;

    /**
     * @author maciek
     */
    public class SimpleQueryTest extends ConnectedTestBase {

        [Test(async,timeout=1000)]
        public function testSelectText() : void {
            var dummyDispatcher : IEventDispatcher = new EventDispatcher();
            Async.proceedOnEvent(this, dummyDispatcher, 'success', 1000);
            var handler:SimpleResultHandler = new SimpleResultHandler(
                function(command : String, rowCount : int) : void {
                    // Note that rowCount for a SELECT does *not* reflect the number of affected rows
                    assertEquals(0, rowCount);
                    assertEquals('SELECT', command);
                    assertEquals(2, handler.columns.length);
                    assertEquals(1, handler.data.length);
                    dummyDispatcher.dispatchEvent(new Event('success'));
                }
            );
            var sql:String = "select ''::text as empty, 'hello world'::text as txt";
            var qt:QueryToken = connection.execute(sql, handler);
            assertNotNull(qt);
            assertEquals(qt.sql, sql);
        }
    }
}
