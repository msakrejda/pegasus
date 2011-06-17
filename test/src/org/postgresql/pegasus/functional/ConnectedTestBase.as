package org.postgresql.pegasus.functional {
    import flash.events.IEventDispatcher;
    import org.flexunit.async.Async;
    import org.postgresql.db.ConnectionFactory;
    import org.postgresql.db.IConnection;
    import org.postgresql.event.ConnectionEvent;
    import org.postgresql.log.ILogger;
    import org.postgresql.log.Log;
    import org.postgresql.pegasus.Credentials;

    public /* abstract */ class ConnectedTestBase {

        private const LOGGER:ILogger = Log.getLogger(Object(this).constructor as Class);

        protected var connection:IConnection;

        [Before(async,timeout=1000)]
        public function setup():void {
            LOGGER.debug("Creating connection.");
            connection = new ConnectionFactory().createConnection(Credentials.url, Credentials.user, Credentials.password);
            // TODO: register failure event on Connection error
            Async.proceedOnEvent(this, IEventDispatcher(connection), ConnectionEvent.CONNECTED);
            LOGGER.debug("Created");
        }

        [After(async,timeout=1000)]
        public function tearDown():void {
            LOGGER.debug("Closing connection.");
            connection.close();
            connection = null;
            LOGGER.debug("Closed.");
        }
    }
}
