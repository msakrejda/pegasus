package org.postgresql.febe {

	public interface IQueryHandler {
		/**
		 * Handle the FieldDescription metadata relating to this query.
		 * This will be called before handleMetadata or handleCompletion.
		 *
		 * @param fields an array of FieldDescription objects.
		 */
		function handleMetadata(fields:Array):void;
		/**
		 * Handle the data relating to this query. The argument will
		 * be an array of an arbitrary number of arrays corresponding
		 * to the raw bytes for each field. This method will be called
		 * zero or more times before handleCompletion is called. 
		 */
		function handleData(rows:Array):void;
		/**
		 * Indicates successful completion of a query. After this is
		 * called, no other methods on this IQueryHandler will be called. 
		 */
		function handleCompletion(command:String, affected:int=0, oid:int=-1):void;
	}
}