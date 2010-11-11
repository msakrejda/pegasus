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
        
        protected var connection:IConnection;
        
        [Before(async,timeout=1000)]
        public function setup():void {
            var connFactory:ConnectionFactory = new ConnectionFactory();
            connection = connFactory.createConnection(Credentials.url, Credentials.user, Credentials.password);
            Async.proceedOnEvent(this, connection, ConnectionEvent.CONNECTED);
        }
        [After(async,timeout=1000)]
        public function tearDown():void {
            connection.close();
        }
    }
}
