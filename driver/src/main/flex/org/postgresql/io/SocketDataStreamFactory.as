package org.postgresql.io {

    public class SocketDataStreamFactory implements IDataStreamFactory {

        private var _host:String;
        private var _port:int;

        public function SocketDataStreamFactory(host:String, port:int) {
            _host = host;
            _port = port;
        }

        public function create():IDataStream {
            return new SocketDataStream(_host, _port);
        }
        
    }
}