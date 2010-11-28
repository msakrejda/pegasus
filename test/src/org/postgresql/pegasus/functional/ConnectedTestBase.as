package org.postgresql.pegasus.functional {
    import org.postgresql.event.ConnectionEvent;
    import org.flexunit.async.Async;
    import org.postgresql.db.IConnection;
    import org.postgresql.pegasus.Credentials;
    import org.postgresql.db.ConnectionFactory;
    /**
     * @author maciek
     */
    public /* abstract */ class ConnectedTestBase {

        protected static var connectionFactory:ConnectionFactory;
        protected static var connection:IConnection;
        protected static var setupCount:int;

        protected function createConnection():IConnection {
        	// We can't really create the connection factory (or connection, for that matter)
        	// in a [BeforeClass] method, because that does not play well with inheritance.
            if (!connectionFactory) {
            	connectionFactory = new ConnectionFactory();
            }
        	var conn:IConnection = new ConnectionFactory().createConnection(Credentials.url, Credentials.user, Credentials.password);
        	// TODO: register failure event on Connection error, once we broadcast
        	// connection errors.
        	Async.proceedOnEvent(this, conn, ConnectionEvent.CONNECTED);
        	return conn;
        }
        
        [Before(async,timeout=1000)]
        public function setup():void {
            if (!connection) {
            	connection = createConnection();
            }
            setupCount++;
        }

        [After(async,timeout=1000)]
        public function tearDown():void {
        	setupCount--;
        	if (setupCount == 0) {
                connection.close();
                connection = null;
        	}
        }
    }
}
