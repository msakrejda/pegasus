package org.postgresql.db.impl {
import org.postgresql.EncodingFormat;
import org.postgresql.Oid;
import org.postgresql.codec.CodecFactory;
import org.postgresql.codec.IPGTypeEncoder;
import org.postgresql.db.IResultHandler;
import org.postgresql.db.QueryToken;
import org.postgresql.febe.ArgumentInfo;
import org.postgresql.febe.IExtendedQueryHandler;
import org.postgresql.io.ByteDataStream;
import org.postgresql.util.getType;

/**
 * Default implementation of <code>IExtendedQueryHandler</code>.
 */
public class ExtendedQueryHandler extends SimpleQueryHandler implements IExtendedQueryHandler {

   /**
    * Constructor.
    *
    * @param resultHandler result handler to pass results to
    * @param codecs codec factory for parameter encoding
    */
   public function ExtendedQueryHandler(resultHandler:IResultHandler, codecs:CodecFactory, token:QueryToken) {
      super(resultHandler, codecs, token);
   }

   /**
    * Describe arguments by using the <code>CodecFactory</code>. Parameters are always encoded
    * in <code>TEXT</code> mode for symmetry with decoding.
    */
   public function describeArguments(params:Array, serverParams:Object):Array {
      var encodedArgs:Array = [];
      for each (var arg:Object in params) {
         var argInfo:ArgumentInfo;
         if (arg == null) {
            argInfo = new ArgumentInfo(EncodingFormat.TEXT, Oid.UNSPECIFIED, null);
         } else {
            var argType:Class = getType(arg);
            var argEncoder:IPGTypeEncoder = _codecFactory.getEncoder(argType);
            var argOid:int = argEncoder.getInputOid(argType);
            var encodedValue:ByteDataStream = new ByteDataStream();

            argEncoder.encode(encodedValue, arg, EncodingFormat.TEXT, serverParams);
            argInfo = new ArgumentInfo(EncodingFormat.TEXT, argOid, encodedValue);
         }
         encodedArgs.push(argInfo);
      }
      return encodedArgs;
   }

   /**
    * Always request output in <code>TEXT</code> mode. Since text handlers are already
    * required for the simple query protocol, and since choosing this per-type is too complex
    * (the driver would need to know the number of columns before executing the query or
    * require an extra round trip), <code>TEXT</code> is a reasonable choice.
    */
   public function getOutputFormats(fieldDescriptions:Array):Array {
      return [EncodingFormat.TEXT];
   }
}
}
