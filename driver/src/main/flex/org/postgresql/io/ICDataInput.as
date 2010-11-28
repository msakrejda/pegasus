package org.postgresql.io {

    import flash.utils.IDataInput;
    /**
     * Augments parent class by adding a read method for a null-terminated String.
     *
     * @see flash.utils.IDataInput
     */
    public interface ICDataInput extends IDataInput {
        /**
         * Reads a C-style, NULL-terminated String from the stream.
         * <br/>
         * Consumes input until it finds the NULL byte 0x00--everything
         * up to that is considered the next String.
         *
         * @param str String to write out
         * @return the decoded String
         */
        function readCString():String;
    }
}