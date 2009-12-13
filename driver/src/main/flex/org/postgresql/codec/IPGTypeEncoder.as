package org.postgresql.codec {

    import org.postgresql.io.ICDataOutput;

    public interface IPGTypeEncoder {
    	/**
    	 * Encode the given value into the provided byte array. The encoding
    	 * may be defined by the server parameters. A given encoder will only
    	 * be asked to process one type of format (currently only
    	 * FieldDescription.BINARY_FORMAT or FieldDescription.TEXT_FORMAT).
    	 */
        function encode(bytes:ICDataOutput, serverParams:Object, value:Object):void;
    }
}