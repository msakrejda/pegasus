package org.postgresql.db {

    import org.postgresql.Oid;
    import org.postgresql.codec.CodecFactory;
    import org.postgresql.codec.decode.DateOut;
    import org.postgresql.codec.decode.FloatOut;
    import org.postgresql.codec.decode.IntOut;
    import org.postgresql.codec.decode.TextOut;
    import org.postgresql.febe.FEBEConnection;
    import org.postgresql.febe.MessageStreamFactory;
    import org.postgresql.io.SocketDataStreamFactory;
    import org.postgresql.util.PgURL;

    /**
     * A simple wiring of all the pegasus pieces into a single, simple interface.
     *
     * This essentially configures a default set of options for pegasus, including CodecFactory
     * and various other factories. The other pegasus classes are designed with reusability
     * and flexibility in mind; ConnectionFactory provides a facade to all that which is primarily
     * concerned with simplicity.
     */
    public class ConnectionFactory {

        private var _codecFactory:CodecFactory;

        public function ConnectionFactory() {
            _codecFactory = new CodecFactory();
            _codecFactory.registerDecoder(Oid.INT2, int, new IntOut());
            _codecFactory.registerDecoder(Oid.INT4, int, new IntOut());
            _codecFactory.registerDecoder(Oid.FLOAT4, int, new FloatOut());
            _codecFactory.registerDecoder(Oid.FLOAT8, int, new FloatOut());
            _codecFactory.registerDecoder(Oid.TIMESTAMP, Date, new DateOut());
            _codecFactory.registerDecoder(Oid.TIMESTAMPTZ, Date, new DateOut());
            _codecFactory.registerDecoder(Oid.BPCHAR, String, new TextOut());
            _codecFactory.registerDecoder(Oid.VARCHAR, String, new TextOut());
            _codecFactory.registerDecoder(Oid.CHAR, String, new TextOut());
            _codecFactory.registerDecoder(Oid.TEXT, String, new TextOut());
            // Technically, this isn't right, especially for binary, but
            // it's at least moderately useful and better than the alternative of
            // CodecErrors everywhere. This typically occurs if someone is selecting
            // text literals: e.g., "SELECT 'foo'".
            _codecFactory.registerDecoder(Oid.UNKNOWN, String, new TextOut());
        }

        public function createConnection(url:String, user:String, password:String):IConnection {
            var pegasusUrl:PgURL = new PgURL(url);

            var brokerFactory:MessageStreamFactory =
                new MessageStreamFactory(
                    new SocketDataStreamFactory(pegasusUrl.host, pegasusUrl.port));
            var params:Object = {};
            for (var key:String in pegasusUrl.parameters) {
                params[key] = pegasusUrl.parameters[key];
            }
            params.user = user;
            var febeConn:FEBEConnection = new FEBEConnection(params, password, brokerFactory);
            var conn:Connection = new Connection(febeConn, new QueryHandlerFactory(_codecFactory));
            return conn;
        }
    }
}