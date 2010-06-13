package org.postgresql.codec {

    import flash.utils.Dictionary;

    public class CodecFactory {

        private var _decoders:Dictionary;
        private var _encoders:Dictionary;

        private var _typeToOid:Dictionary;
        private var _oidToType:Dictionary;

        // TODO: handle defaults. On input, any unknown type should be mapped
        // to Oid.UNSPECIFIED and sent as its String representation. On output,
        // if sent as text, we can destringify and present text. 
        public function CodecFactory() {
            _decoders = new Dictionary();
            _encoders = new Dictionary();

            _typeToOid = new Dictionary();
            _oidToType = new Dictionary();
        }

        public function registerEncoder(inType:Class, inOid:int, encoder:IPGTypeEncoder):void {
            _encoders[inType] = encoder;
            _typeToOid[inType] = inOid;
        }

        public function registerDecoder(outOid:int, outType:Class, decoder:IPGTypeDecoder):void {
            _decoders[outOid] = decoder;
            _oidToType[outOid] = outType;
        }

        public function getDecoder(oid:int):IPGTypeDecoder {
            return _decoders[oid];
        }

		public function getOutputClass(oid:int):Class {
			return _oidToType[oid];
		}

        public function getEncoder(value:Object):IPGTypeEncoder {
        	if (value is int) {
        		return _encoders[int];
        	} else if (value is uint) {
        		return _encoders[uint];
        	} else {
        		return _encoders[Object(value).constructor];
        	}
        }

    }
}