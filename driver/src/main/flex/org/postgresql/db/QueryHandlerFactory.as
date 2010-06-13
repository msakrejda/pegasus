package org.postgresql.db {

    import org.postgresql.codec.CodecFactory;
    
    public class QueryHandlerFactory {

        private var _codecFactory:CodecFactory;

        public function QueryHandlerFactory(codecFactory:CodecFactory) {
            _codecFactory = codecFactory;
        }
        
        public function createSimpleHandler(resultHandler:IResultHandler):SimpleQueryHandler {
            return new SimpleQueryHandler(resultHandler, _codecFactory);
        }

    }
}