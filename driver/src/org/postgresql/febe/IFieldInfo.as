package org.postgresql.febe {

    /**
     * Metadata for a field communicated with the backend.
     */
    public interface IFieldInfo {

        /**
         * The encoding format of the field
         * @see org.postgresql.EncodingFormat
         */
        function get format():int;

        /**
         * The oid of the PostgreSQL data type of this field
         * @see org.postgresql.Oid
         */
        function get typeOid():int;
    }
}