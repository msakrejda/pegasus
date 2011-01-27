package org.postgresql.io {

    /**
     * Factory class to create <code>SocketDataStream</code>s to a given
     * host and port.
     *
     * @see SocketDataStream
     */
    public class SocketDataStreamFactory implements IDataStreamFactory {

        private var _host:String;
        private var _port:int;

        /**
         * Create a new factory for connections to given host and port
         *
         * @param host host to connect to
         * @param port port to connect to
         */
        public function SocketDataStreamFactory(host:String, port:int) {
            _host = host;
            _port = port;
        }

        /**
         * @inheritDoc
         */
        public function create():IDataStream {
            return new SocketDataStream(_host, _port);
        }

    }
}