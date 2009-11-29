package org.postgresql.codec {

    import flash.utils.Dictionary;
    // This needs more context. The encoding / decoding is based not just
    // on data types, but also on selected encoding (text vs. binary),
    // and possibly typmod / size of the field.
    public class TypeCodecFactory {

        private var _decoders:Dictionary;
        private var _encoders:Dictionary;

        private var _defaultEncoder:IPGTypeEncoder;
        private var _defaultDecoder:IPGTypeDecoder;

        public function TypeCodecFactory() {
            _decoders = new Dictionary();
            _encoders = new Dictionary();
            _defaultDecoder = new DefaultCodec();
            _defaultEncoder = new DefaultCodec();
        }

        public function registerEncoder(type:Class, encoder:IPGTypeEncoder):void {
            _encoders[type] = encoder;
        }

        public function registerDecoder(oid:int, decoder:IPGTypeDecoder):void {
            _decoders[oid] = decoder;
        }

        public function getDecoder(oid:int):IPGTypeDecoder {
            return _decoders[oid] || _defaultDecoder;
        }

        public function getEncoder(value:Object):IPGTypeEncoder {
            return (value is int ? _encoders[int] : _encoders[value.constructor]) || _defaultEncoder;
        }

    }
}