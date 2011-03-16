package org.postgresql.pegasus.functional {

    import org.postgresql.db.IColumn;
    import org.postgresql.db.event.QueryResultEvent;
    import org.flexunit.asserts.assertEquals;

    public class ExtendedQueryTest extends SelectTestBase {

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
            runQuery(verifyFn, sql, [ 0 ]);
        }


    }
}
