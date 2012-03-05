package org.postgresql.db.impl {
import org.postgresql.codec.CodecFactory;
import org.postgresql.db.IResultHandler;
import org.postgresql.db.QueryToken;
import org.postgresql.febe.IExtendedQueryHandler;
import org.postgresql.febe.IQueryHandler;

/**
 * Factory for creating new query handlers.
 */
public class QueryHandlerFactory {

   private var _codecFactory:CodecFactory;

   /**
    * Constructor.
    *
    * @param codecFactory CodecFactory to use
    */
   public function QueryHandlerFactory(codecFactory:CodecFactory) {
      _codecFactory = codecFactory;
   }

   /**
    * Create new <code>IQueryHandler</code> wiht the given <code>IResultHandler</code>.
    *
    * @param resultHandler IResultHandler to use
    */
   public function createSimpleHandler(resultHandler:IResultHandler, token:QueryToken):IQueryHandler {
      return new SimpleQueryHandler(resultHandler, _codecFactory, token);
   }

   /**
    * Create a new <code>IExtendedQueryHandler</code> with the given <code>IResultHanlder</code>.
    *
    * @param resultHandler IResultHandler to use
    */
   public function createExtendedHandler(resultHandler:IResultHandler, token:QueryToken):IExtendedQueryHandler {
      return new ExtendedQueryHandler(resultHandler, _codecFactory, token);
   }

}
}
