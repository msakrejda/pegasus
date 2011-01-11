package org.postgresql.codec {

    import org.postgresql.Oid;
    import flash.utils.Dictionary;

    import org.postgresql.CodecError;

    /**
     * The CodecFactory manages mappings between ActionScript Objects (of certain
     * Classes) and PostgreSQL column values (of certain oids). A Class can be mapped
     * to an oid registering an encoder, and an oid to a Class through a decoder.
     * Only a single mapping can exist for a given oid (or Class) at any given time.
     *
     * @see org.postgresql.Oid
     * @see Class
     */
    public class CodecFactory {

        private var _decoders:Dictionary;
        private var _encoders:Dictionary;

        private var _typeToOid:Dictionary;
        private var _oidToType:Dictionary;

        /**
         * Constructor. No encoders or decoders are registered by default.
         */
        public function CodecFactory() {
            // TODO: handle defaults. On input, any unknown type should be mapped
            // to Oid.UNSPECIFIED and sent as its String representation. On output,
            // if sent as text, we can destringify and present text.
            _decoders = new Dictionary();
            _encoders = new Dictionary();

            _typeToOid = new Dictionary();
            _oidToType = new Dictionary();
        }

        /**
         * Register the given encoder to map values of the inType to the inOid. If
         * an encoder was previously registered for the same inType, it is silently
         * replaced.
         *
         * @param inType
         * @param inOid
         * @param encoder
         */
        public function registerEncoder(inType:Class, inOid:int, encoder:IPGTypeEncoder):void {
            _encoders[inType] = encoder;
            _typeToOid[inType] = inOid;
        }

        /**
         * Register the given decoder to map values of the given outOid to the outType. If
         * a decoder was previously registered for the same outOid, it is silently replaced.
         *
         * @param outOid
         * @param outType
         * @param decoder
         */
        public function registerDecoder(outOid:int, outType:Class, decoder:IPGTypeDecoder):void {
            _decoders[outOid] = decoder;
            _oidToType[outOid] = outType;
        }

        /**
         * Return the decoder for the given oid
         * @param oid oid for which to find decoder
         * @return registered decoder
         * @throws org.postgresql.CodecError if no decoder has been registered for the given oid
         */
        public function getDecoder(oid:int):IPGTypeDecoder {
            if (oid in _decoders) {
                return _decoders[oid];
            } else {
                throw new CodecError("Could not find suitable decoder", CodecError.DECODE, null, oid);
            }
        }

        /**
         * Return the Class given oid is currently mapped to.
         * @param oid oid for which to find mapped Class
         * @return Class mapped (or null if none)
         */
        public function getOutputClass(oid:int):Class {
            return _oidToType[oid];
        }

        /**
         * Return the encoder for the given Class
         * @param value for which to find encoder
         * @return registered encoder
         * @throws org.postgresql.CodecError if no encoder is registered for the given Class
         */
        public function getEncoder(clazz:Class):IPGTypeEncoder {
            if (clazz in _encoders) {
                return _encoders[clazz];
            } else {
                throw new CodecError("Could not find suitable encoder", CodecError.ENCODE, null, Oid.UNSPECIFIED, clazz);
            }
        }

    }
}