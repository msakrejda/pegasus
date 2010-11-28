package org.postgresql.io {

    import flash.utils.IDataOutput;
    /**
     * Augments parent class by adding a write method for a null-terminated String.
     *
     * @see flash.utils.IDataOutput
     */
    public interface ICDataOutput extends IDataOutput {
        /**
         * Write a C-style, NULL-terminated String to the stream.
         *
         * @param str String to write out
         */
        function writeCString(str:String):void;
    }
}