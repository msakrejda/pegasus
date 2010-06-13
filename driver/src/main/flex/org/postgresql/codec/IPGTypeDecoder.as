package org.postgresql.codec {

    import org.postgresql.febe.FieldDescription;
    import org.postgresql.io.ICDataInput;

    public interface IPGTypeDecoder {
    	/**
    	 * Decode the given value from the encoded byte array. The encoding
    	 * may be defined by the field description and server parameters.
    	 */ 
        function decode(bytes:ICDataInput, format:FieldDescription, serverParams:Object):Object;
    }
}