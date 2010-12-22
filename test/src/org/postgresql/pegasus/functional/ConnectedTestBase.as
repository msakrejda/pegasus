package org.postgresql.pegasus.functional {
    import org.flexunit.async.Async;
    import org.postgresql.db.ConnectionFactory;
    import org.postgresql.db.IConnection;
    import org.postgresql.event.ConnectionEvent;
    import org.postgresql.log.ILogger;
    import org.postgresql.log.Log;
    import org.postgresql.pegasus.Credentials;
    /**
     * @author maciek
     */
    public /* abstract */ class ConnectedTestBase {

        private const LOGGER:ILogger = Log.getLogger(Object(this).constructor);

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
                LOGGER.debug("Creating connection.");
                connection = createConnection();
                LOGGER.debug("Created");
            }
            setupCount++;
        }

        [After(async,timeout=1000)]
        public function tearDown():void {
            setupCount--;
            if (setupCount == 0) {
                LOGGER.debug("Closing connection.");
                connection.close();
                connection = null;
                LOGGER.debug("Closed.");
            }
        }
    }
}
