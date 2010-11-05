package org.postgresql.db {

    import flash.events.EventDispatcher;
    
    import org.postgresql.CodecError;
    import org.postgresql.codec.CodecFactory;
    import org.postgresql.codec.IPGTypeDecoder;
    import org.postgresql.febe.FieldDescription;
    import org.postgresql.febe.IQueryHandler;
    import org.postgresql.log.ILogger;
    import org.postgresql.log.Log;
    
    internal class SimpleQueryHandler extends EventDispatcher implements IQueryHandler {

        private static const LOGGER:ILogger = Log.getLogger(SimpleQueryHandler);
    
        private var _codecFactory:CodecFactory;
        private var _resultHandler:IResultHandler;
        private var _fields:Array;
        private var _decoders:Array;
    
        public function SimpleQueryHandler(resultHandler:IResultHandler, codecs:CodecFactory) {
            _resultHandler = resultHandler;
            _codecFactory = codecs;
        }

        public function handleMetadata(fields:Array):void {
            _fields = fields;
            _decoders = [];
            var columns:Array = [];
            for each (var f:FieldDescription in fields) {
                var decoder:IPGTypeDecoder = _codecFactory.getDecoder(f.typeOid);
                _decoders.push(decoder);
                // TODO: ColumnFactory?
                columns.push(new Column(f.name, _codecFactory.getOutputClass(f.typeOid), f.typeOid));
            }
            LOGGER.debug("Got fields: {0}", fields.join(' '));
            _resultHandler.handleColumns(columns);
        }

        public function handleData(rows:Array, serverParams:Object):void {
            for each (var row:Array in rows) {
                var decodedRow:Array = [];
                for (var i:int = 0; i < row.length; i++) { 
                    if (row[i]) {
                        try {
                               decodedRow.push(_decoders[i].decode(row[i], _fields[i], serverParams));
                           } catch (e:Error) {
                               var oid:int = _fields[i].typeOid;
                               var codecErr:CodecError = new CodecError("Error decoding", CodecError.DECODE, oid,
                                   _codecFactory.getOutputClass(oid));
                               codecErr.error = e;
                               throw codecErr;
                           }
                    } else {
                        decodedRow.push(null);
                    }
                }
                _resultHandler.handleRow(decodedRow);
            }
        }
    
        public function handleCompletion(command:String, rows:int=0, oid:int=-1):void {
            _resultHandler.handleCompletion(command, rows, oid);
        }
    
        public function dispose():void {
        	_resultHandler.dispose();
        }

    }
}