package org.postgresql.febe {

    import org.postgresql.io.IDataStreamFactory;

    public class MessageBrokerFactory {

        private var _streamFactory:IDataStreamFactory;

        public function MessageBrokerFactory(streamFactory:IDataStreamFactory) {
            _streamFactory = streamFactory;
        }

        public function create():MessageBroker {
            return new MessageBroker(_streamFactory.create());
        }

    }
}