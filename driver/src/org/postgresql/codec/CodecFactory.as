package org.postgresql.codec {

    import org.postgresql.Oid;
    import flash.utils.Dictionary;

    import org.postgresql.CodecError;

    /**
     * Manages mappings between ActionScript Objects (of certain Classes) and PostgreSQL
     * column values (of certain oids). A Class can be mapped to an oid by registering an
     * encoder, and an oid to a Class through a decoder. Only a single mapping can exist for
     * a given oid (or Class) at any given time.
     * <p/>
     * Default encoders and decoders can also be registered. These are used as fallback
     * and are used when no encoder (or decoder) exists for a given Class (or oid).
     * <p/>
     * No encoders or decoders are registered by default.
     *
     * @see org.postgresql.Oid
     * @see Class
     */
    public class CodecFactory {

        private var _decoders:Dictionary;
        private var _encoders:Dictionary;

        private var _defaultDecoder:IPGTypeDecoder;
        private var _defaultEncoder:IPGTypeEncoder;

        /**
         * @private
         */
        public function CodecFactory() {
            _decoders = new Dictionary();
            _encoders = new Dictionary();
        }

        /**
         * Register the given encoder to map values of the inType to an oid. If
         * an encoder was previously registered for the same inType, it is silently
         * replaced.
         *
         * @param inType Class for which to register mapping
         * @param encoder encoder instance to use for given class
         */
        public function registerEncoder(inType:Class, encoder:IPGTypeEncoder):void {
            if (!encoder) {
                throw new ArgumentError("Encoder must not be null");
            }
            if (!inType) {
                throw new ArgumentError("Class to be mapped must not be null");
            }
            _encoders[inType] = encoder;
        }

        /**
         * Register a encoder to map values when no other encoder is suitable. If
         * a previous default encoder was specified, it is silently replaced.
         *
         * @param encoder encoder instance for default encoding
         */
        public function registerDefaultEncoder(encoder:IPGTypeEncoder):void {
            if (!encoder) {
                throw new ArgumentError("Encoder must not be null");
            }
            _defaultEncoder = encoder;
        }

        /**
         * Register the given decoder to map values of the given outOid to an ActionScript type. If
         * a decoder was previously registered for the same outOid, it is silently replaced.
         *
         * @param outOid oid for which to register mapping
         * @param decoder decoder instance to use for given oid
         */
        public function registerDecoder(outOid:int, decoder:IPGTypeDecoder):void {
            if (!decoder) {
                throw new ArgumentError("Decoder must not be null");
            }
            _decoders[outOid] = decoder;
        }

        /**
         * Register a decoder to map values when no other decoder is suitable. If
         * a previous default decoder was specified, it is silently replaced.
         *
         * @param decoder decoder instance to use for default decoding
         */
        public function registerDefaultDecoder(decoder:IPGTypeDecoder):void {
            if (!decoder) {
                throw new ArgumentError("Decoder must not be null");
            }
            _defaultDecoder = decoder;
        }

        /**
         * Return the decoder for the given oid
         *
         * @param oid oid for which to find decoder
         * @return registered decoder
         * @throws org.postgresql.CodecError if no decoder has been registered for the given oid
         */
        public function getDecoder(oid:int):IPGTypeDecoder {
            if (oid in _decoders) {
                return _decoders[oid];
            } else if (_defaultDecoder) {
                return _defaultDecoder;
            } else {
                throw new CodecError("Could not find suitable decoder", CodecError.DECODE, null, oid);
            }
        }

        /**
         * Return the encoder for the given Class
         *
         * @param value for which to find encoder
         * @return registered encoder
         * @throws org.postgresql.CodecError if no encoder is registered for the given Class
         */
        public function getEncoder(clazz:Class):IPGTypeEncoder {
            if (clazz in _encoders) {
                return _encoders[clazz];
            } else if (_defaultEncoder) {
                return _defaultEncoder;
            } else {
                throw new CodecError("Could not find suitable encoder", CodecError.ENCODE, null, Oid.UNSPECIFIED, clazz);
            }
        }

    }
}