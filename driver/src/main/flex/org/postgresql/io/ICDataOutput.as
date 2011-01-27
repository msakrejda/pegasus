package org.postgresql.io {

    import flash.utils.IDataOutput;
    /**
     * An <code>IDataInput</code> that can also write null-terminated character strings from ActionScript <code>String</code>s
     *
     * @see flash.utils.IDataOutput
     */
    public interface ICDataOutput extends IDataOutput {
        /**
         * Write a C-style, NULL-terminated String to the stream. This will write
         * the bytes of the given String followed by the byte <code>0x00</code>.
         *
         * @param str String to write out
         */
        function writeCString(str:String):void;
    }
}