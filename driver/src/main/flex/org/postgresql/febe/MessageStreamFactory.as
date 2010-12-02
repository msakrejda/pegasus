package org.postgresql.febe {

    import org.postgresql.io.IDataStreamFactory;

    public class MessageStreamFactory {

        private var _streamFactory:IDataStreamFactory;

        public function MessageStreamFactory(streamFactory:IDataStreamFactory) {
            _streamFactory = streamFactory;
        }

        public function create():IMessageStream {
            return new MessageStream(_streamFactory.create());
        }

    }
}