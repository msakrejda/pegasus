package org.postgresql.db {

    internal interface IResultHandler {
    	/**
    	 * @param fields map of NoticeField code to detail text for that field. 
    	 */
        function handleNotice(fields:Object):void;
    	/**
    	 * @param fields map of NoticeField code to detail text for that field. 
    	 */        
        function handleError(fields:Object):void;
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
         * 				the insert is a single row, 0 on other INSERT, -1 otherwise 
         */
        function handleCompletion(command:String, rows:int, oid:int):void;
    }
}