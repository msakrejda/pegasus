package org.postgresql.io {

    import flash.utils.IDataInput;
    /**
     * An <code>IDataInput</code> that can also read null-terminated character strings.
     *
     * @see flash.utils.IDataInput
     */
    public interface ICDataInput extends IDataInput {
        /**
         * Reads a C-style, NULL-terminated String from the stream.
         * <br/>
         * Consumes input until it finds the NULL byte <code>0x00</code>--everything
         * up to (but not including) this byte is considered part of the String.
         *
         * @return the decoded String
         */
        function readCString():String;
    }
}