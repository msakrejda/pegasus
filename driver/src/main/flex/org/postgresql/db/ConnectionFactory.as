package org.postgresql.db {

    import org.postgresql.Oid;
    import org.postgresql.codec.CodecFactory;
    import org.postgresql.codec.decode.DateOut;
    import org.postgresql.codec.decode.FloatOut;
    import org.postgresql.codec.decode.IntOut;
    import org.postgresql.codec.decode.TextOut;
    import org.postgresql.febe.FEBEConnection;
    import org.postgresql.febe.MessageBrokerFactory;
    import org.postgresql.io.SocketDataStreamFactory;
    import org.postgresql.util.DbURL;

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
    	}

        public function createConnection(url:String, username:String, password:String):IConnection {
        	var pegasusUrl:DbURL = new DbURL(url);

            var brokerFactory:MessageBrokerFactory =
                new MessageBrokerFactory(
                    new SocketDataStreamFactory(pegasusUrl.host, pegasusUrl.port));
            var params:Object = {};
            for (var key:String in pegasusUrl.parameters) {
            	params[key] = pegasusUrl.parameters[key];
            }
            params.username = username;
            var febeConn:FEBEConnection = new FEBEConnection(params, password, brokerFactory);
            var conn:Connection = new Connection(febeConn, new QueryHandlerFactory(_codecFactory));
            return conn;
        }
    }
}