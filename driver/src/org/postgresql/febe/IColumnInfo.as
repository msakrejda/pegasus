package org.postgresql.febe {
    /**
     * Metadata for a query result column.
     */
    public interface IColumnInfo extends IFieldInfo {
        /**
         * The column name of the field (either explicit alias or generated)
         */
        function get name():String
    }
}
