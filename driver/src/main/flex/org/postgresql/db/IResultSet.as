package org.postgresql.db {

    import flash.events.IEventDispatcher;

    /**
     * The result of executing a single query. Notice that a result set may dispatch
     * NoticeEvent.NOTICE or NoticeEvent.ERROR in the course of query execution.
     * NoticeEvent.NOTICE is likely to be purely informative, but NoticeEvent.ERROR
     * will signal aborted query execution due to an error. The event itself will
     * contain details on the error.
     */
    public interface IResultSet extends IEventDispatcher {
    	/**
    	 * An Array of IColumn instances describing the fields in this result set.
    	 * Available after the result set dispatches the MetadataEvent.METADATA event.
    	 */
        function get columns():Array;
    	/**
    	 * Data returned by this query, as an Array of Objects, each mapping column names
    	 * (as present in the <code>columns</code> Array) to their values for that row.
    	 * <br/>
    	 * Available after the result set dispatches ResultSetEvent.RESULT event.
    	 */ 
        function get data():Array;
        /**
         * Release the resources held by this result set. 
         */
        function close():void;
    }
}