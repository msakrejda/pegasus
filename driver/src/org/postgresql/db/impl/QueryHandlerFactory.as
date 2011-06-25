package org.postgresql.db.impl {
    import org.postgresql.codec.CodecFactory;
    import org.postgresql.db.IResultHandler;
    import org.postgresql.febe.IExtendedQueryHandler;
    import org.postgresql.febe.IQueryHandler;

    public class QueryHandlerFactory {

        private var _codecFactory:CodecFactory;

        public function QueryHandlerFactory(codecFactory:CodecFactory) {
            _codecFactory = codecFactory;
        }

        public function createSimpleHandler(resultHandler:IResultHandler):IQueryHandler {
            return new SimpleQueryHandler(resultHandler, _codecFactory);
        }

        public function createExtendedHandler(resultHandler:IResultHandler):IExtendedQueryHandler {
            return new ExtendedQueryHandler(resultHandler, _codecFactory);
        }

    }
}