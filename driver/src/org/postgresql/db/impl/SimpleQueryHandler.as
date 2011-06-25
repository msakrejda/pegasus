package org.postgresql.db.impl {

    import flash.events.EventDispatcher;
    import org.postgresql.CodecError;
    import org.postgresql.codec.CodecFactory;
    import org.postgresql.codec.IPGTypeDecoder;
    import org.postgresql.db.IResultHandler;
    import org.postgresql.febe.FieldDescription;
    import org.postgresql.febe.IQueryHandler;
    import org.postgresql.log.ILogger;
    import org.postgresql.log.Log;


    /**
     * A simple implementation of the <code>IQueryHandler</code> interface to transform
     * the low-level results handed off to <code>IQueryHandler</code>s into something
     * more appropriate to the higher-level interface presented in the <code>org.postgresql.db</code>
     * package.
     *
     * @private
     */
    internal class SimpleQueryHandler extends EventDispatcher implements IQueryHandler {

        protected var _codecFactory:CodecFactory;
        protected var _resultHandler:IResultHandler;
        protected var _fields:Array;
        protected var _decoders:Array;

        /**
         * Create a new simple query handler.
         *
         * @param resultHandler <code>IResutHandler</code> to which results will be handed
         * @param codecs CodecFactory to use for decoding query data
         */
        public function SimpleQueryHandler(resultHandler:IResultHandler, codecs:CodecFactory) {
            _resultHandler = resultHandler;
            _codecFactory = codecs;
        }

        /**
         * Handle query metadata. The PostgreSQL metadata is transformed into <code>IColumn</code>
         * instances describing the data in terms of ActionScript classes and then handed off to the
         * wrapped <code>IResultHandler</code>.
         *
         * @param fields <code>Array</code> of <code>FieldDescription</code> instances describing the data
         */
        public function handleMetadata(fields:Array):void {
            _fields = fields;
            _decoders = [];
            var columns:Array = [];
            for each (var f:FieldDescription in fields) {
                var decoder:IPGTypeDecoder = _codecFactory.getDecoder(f.typeOid);
                _decoders.push(decoder);
                // TODO: ColumnFactory?
                columns.push(new Column(f.name, decoder.getOutputClass(f.typeOid), f.typeOid));
            }
            _resultHandler.handleColumns(columns);
        }

        /**
         * Handle query data. The data is decoded (according to the <code>FieldDescription</code>s and the
         * <code>serverParams</code>) and handed off to the wrapped <code>IResultHandler</code> row by row.
         *
         * @param rows <code>Array</code> of <code>Array</code>s of <code>ByteArray</code>s containing the (encoded) query results
         * @param serverParams the server parameters at the time data is made available
         */
        public function handleData(rows:Array, serverParams:Object):void {
            for each (var row:Array in rows) {
                var decodedRow:Array = [];
                for (var i:int = 0; i < row.length; i++) {
                    if (row[i]) {
                        try {
                            decodedRow.push(_decoders[i].decode(row[i], _fields[i], serverParams));
                        } catch (e:Error) {
                            var oid:int = _fields[i].typeOid;
                            var outClass:Class = _decoders[i].getOutputClass(oid);
                            var codecErr:CodecError = new CodecError("Error decoding", CodecError.DECODE, e, oid, outClass);
                            throw codecErr;
                        }
                    } else {
                        decodedRow.push(null);
                    }
                }
                _resultHandler.handleRow(decodedRow);
            }
        }

        /**
         * This implementation calls <code>handleCompletion</code> on the wrapped <code>IResultHandler</code>.
         *
         * @param command command tag
         * @param rows number of rows affected, or 0 if not applicable
         * @param oid oid of inserted row, 0 if query was <code>INSERT</code> but did not produce an oid, or -1 if not applicable
         */
        public function handleCompletion(command:String, rows:int=0, oid:int=-1):void {
            _resultHandler.handleCompletion(command, rows, oid);
        }

        /**
         * This implementation calls <code>dispose</code> on the wrapped <code>IResultHandler</code>.
         */
        public function dispose():void {
            _resultHandler.dispose();
        }

    }
}