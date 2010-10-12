package org.postgresql.db {

    public interface IResultHandler {
        /**
         * @param columns Array of IColumn objects describing the data.
         */
        function handleColumns(columns:Array):void;
        /**
         * @param rowData Array of column values corresponding to a single row of results
         */
        function handleRow(rowData:Array):void;
        /**
         * @param command the PostgreSQL tag specifying the command that just completed
         * @param rows the number of rows affected, or -1 if no rows were affected (e.g., a DDL command)
         * @param oid on INSERT, the oid of the inserted row if the target table has oids and
         *                 the insert is a single row, 0 on other INSERT, -1 otherwise 
         */
        function handleCompletion(command:String, rows:int, oid:int):void;
        /**
         * Clean up resources associated with this result handler.
         */
        function dispose():void;
    }
}