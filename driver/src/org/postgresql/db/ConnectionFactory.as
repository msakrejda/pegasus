package org.postgresql.db {
    import org.postgresql.Oid;
    import org.postgresql.PgURL;
    import org.postgresql.codec.CodecFactory;
    import org.postgresql.codec.decode.DateOut;
    import org.postgresql.codec.decode.FloatOut;
    import org.postgresql.codec.decode.IntOut;
    import org.postgresql.codec.decode.TextOut;
    import org.postgresql.codec.encode.BoolIn;
    import org.postgresql.codec.encode.Float8In;
    import org.postgresql.codec.encode.Int4In;
    import org.postgresql.codec.encode.TextIn;
    import org.postgresql.codec.encode.TimestamptzIn;
    import org.postgresql.db.impl.Connection;
    import org.postgresql.db.impl.QueryHandlerFactory;
    import org.postgresql.febe.FEBEConnection;
    import org.postgresql.febe.MessageStreamFactory;
    import org.postgresql.io.SocketDataStreamFactory;
    import org.postgresql.util.DateFormatter;

    // N.B.: The other pegasus classes are designed with reusability and flexibility in mind; ConnectionFactory
    // provides a facade to all that which is primarily concerned with simplicity.

    // TODO: allow some CodecFactory configuration here. Most people won't want to mess with the other
    // stuff, but registering new codecs (or rejiggering existing ones), may be pretty common

    /**
     * The standard way to create a connection in pegasus.
     * <br/>
     * This configures a default set of options for pegasus, including all the default available
     * codecs, and allows usage of a connection URL.
     */
    public class ConnectionFactory {

        private var _codecFactory:CodecFactory;

        /**
         * @private
         */
        public function ConnectionFactory() {
            _codecFactory = new CodecFactory();

            _codecFactory.registerDecoder(Oid.INT2, new IntOut());
            _codecFactory.registerDecoder(Oid.INT4, new IntOut());
            _codecFactory.registerDecoder(Oid.FLOAT4, new FloatOut());
            _codecFactory.registerDecoder(Oid.FLOAT8, new FloatOut());
            _codecFactory.registerDecoder(Oid.TIMESTAMP, new DateOut());
            _codecFactory.registerDecoder(Oid.TIMESTAMPTZ, new DateOut());
            _codecFactory.registerDecoder(Oid.BPCHAR, new TextOut());
            _codecFactory.registerDecoder(Oid.VARCHAR, new TextOut());
            _codecFactory.registerDecoder(Oid.CHAR, new TextOut());
            _codecFactory.registerDecoder(Oid.TEXT, new TextOut());

            _codecFactory.registerEncoder(int, new Int4In());
            _codecFactory.registerEncoder(String, new TextIn());
            _codecFactory.registerEncoder(Number, new Float8In());
            _codecFactory.registerEncoder(Boolean, new BoolIn());
            _codecFactory.registerEncoder(Date, new TimestamptzIn(new DateFormatter(), true));

            _codecFactory.registerDefaultDecoder(new TextOut());
        }

        /**
         * Create a new connection to given URL with the specified credentials. The new connection
         * attempts to connect automatically right after it is created, and will dispatch the
         * relevant events as appropriate.
         *
         * @param url URL to connect to
         * @param user database user to connect as
         * @param password database password for user
         *
         * @return IConnection to given url
         */
        public function createConnection(url:String, user:String, password:String):IConnection {
            var pegasusUrl:PgURL = new PgURL(url);

            var messageStreamFactory:MessageStreamFactory =
                new MessageStreamFactory(
                    new SocketDataStreamFactory(pegasusUrl.host, pegasusUrl.port));
            var params:Object = {};
            for (var key:String in pegasusUrl.parameters) {
                params[key] = pegasusUrl.parameters[key];
            }
            params.user = user;
            params.database = pegasusUrl.db;
            var febeConn:FEBEConnection = new FEBEConnection(params, password, messageStreamFactory);
            var conn:Connection = new Connection(febeConn, new QueryHandlerFactory(_codecFactory));
            return conn;
        }
    }
}