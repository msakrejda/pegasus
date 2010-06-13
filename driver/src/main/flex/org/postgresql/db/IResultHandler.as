package org.postgresql.db {

	internal interface IResultHandler {
		function handleNotice(fields:Object):void;
		function handleError(fields:Object):void;
		function handleColumns(columns:Array):void;
		function handleRow(rowData:Array):void;
		function handleBatch():void;
		function handleCompletion(command:String, rows:int=0, oid:int=-1):void;
		function get statement():IStatement;
	}
}