package org.postgresql.pegasus.util {

    import org.flexunit.Assert;
    import org.postgresql.util.PgURL;    

    [RunWith("org.flexunit.runners.Parameterized")]
    public class TestPgURL {
        
        public static function getTestURLs():Array {
            return [
                [ 'asdbc:postgresql://localhost/pegasus', 'localhost', 5432, 'pegasus', {} ],
                [ 'asdbc:postgresql://example.com/pegasus', 'example.com', 5432, 'pegasus', {} ],
                [ 'asdbc:postgresql://localhost:1234/pegasus', 'localhost', 1234, 'pegasus', {} ],
                [ 'asdbc:postgresql://localhost/testdb', 'localhost', 5432, 'testdb', {} ],
                [ 'asdbc:postgresql://localhost/pegasus?param1=hello&param2=world', 'localhost', 5432, 'pegasus', {
                	   param1: 'hello', param2: 'world'
                } ]
            ];
        }
        
        [Test(dataProvider="getTestURLs")]
        public function testURL(url:String, host:String, port:int, db:String, params:Object):void {
            var pgUrl:PgURL = new PgURL(url);
            Assert.assertEquals(host, pgUrl.host);
            Assert.assertEquals(port, pgUrl.port);
            Assert.assertEquals(db, pgUrl.db);
            for (var key:String in params) {
            	Assert.assertEquals(params[key], pgUrl.parameters[key]);
            }
        }

    }
}