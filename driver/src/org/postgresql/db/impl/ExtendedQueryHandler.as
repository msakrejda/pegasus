package org.postgresql.db.impl {
    import org.postgresql.EncodingFormat;
    import org.postgresql.Oid;
    import org.postgresql.codec.CodecFactory;
    import org.postgresql.codec.IPGTypeEncoder;
    import org.postgresql.db.IResultHandler;
    import org.postgresql.febe.ArgumentInfo;
    import org.postgresql.febe.IExtendedQueryHandler;
    import org.postgresql.io.ByteDataStream;
    import org.postgresql.util.getType;

    public class ExtendedQueryHandler extends SimpleQueryHandler implements IExtendedQueryHandler {

        public function ExtendedQueryHandler(resultHandler:IResultHandler, codecs:CodecFactory) {
            super(resultHandler, codecs);
        }

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

        public function getOutputFormats(fieldDescriptions:Array):Array {
            return [ EncodingFormat.TEXT ];
        }
    }
}
