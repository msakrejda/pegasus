package org.postgresql.db {
    import flash.events.IEventDispatcher;

    /**
     * @eventType org.postgresql.event.ConnectionEvent.DISCONNECTED
     */
    [Event(name='disconnected', type='org.postgresql.event.ConnectionEvent')]

    /**
     * @eventType org.postgresql.event.NoticeEvent.ERROR
     */
    [Event(name='error', type='org.postgresql.event.NoticeEvent')]

    /**
     * @eventType org.postgresql.event.NoticeEvent.NOTICE
     */
    [Event(name='notice', type='org.postgresql.event.NoticeEvent')]

    /**
     * @eventType org.postgresql.event.NotificationEvent.NOTIFICATION
     */
    [Event(name='notification', type='org.postgresql.event.NotificationEvent')]

    /**
     * @eventType org.postgresql.event.ParameterChangeEvent.PARAMETER_CHANGE
     */
    [Event(name='parameterChange', type='org.postgresql.event.ParameterChangeEvent')]

    /**
     * Represents a single connection to a PostgreSQL backend. The IConnection is the
     * central clearinghouse for all communication with a backend. It supports
     * execution (and cancellation) of queries and dispatches events signaling changes
     * in connection state.
     */
    public interface IConnection extends IEventDispatcher {

        /**
         * Execute a query. Note that any query errors are <em>not</em> passed to the
         * handler. They result in <code>NoticeEvent.ERROR</code> events dispatched
         * from the connection.
         * <p/>
         * This method will generally not throw an Error even if the uderlying connection
         * is broken; even synchronous errors will be "rerouted" through the Error event
         * mechanism for uniformity.
         * <p/>
         * Note that the method is asynchronous: it returns before the query actually
         * executes. Query completion information, as well as metadata and results (if any)
         * are passed to the handler provided.
         *
         * @param sql query to be executed
         * @param handler handler to process query metadata, results, and completion
         */
        function execute(sql:String, handler:IResultHandler):QueryToken;
        /**
         * Close the connection. This cleans up any outstanding resources related
         * to the connection. Note that a closed connection cannot be reopened.
         * <p/>
         * Note also that as with execute, this will not throw an Error. At the moment,
         * errors in closing the connection are simply logged and ignored. An error
         * Event for more robust behavior may come in the future.
         * <p/>
         * It is safe (albeit pointless) to call close multiple times.
         */
        function close():void;
        /**
         * Cancel an ongoing or pending query execution. If the QueryToken provided does
         * not match the currently executing query or a pending query, this method
         * returns false. Otherwise, if the token corresponds to a pending query, that
         * query is dequeued and the method returns true. If the token corresponds to the
         * currently executing query, a request is issued to the backend to cancel the
         * query, and this method returns true.
         * <p/>
         * Note that when issuing a cancel request, the actual cancellation is asynchronous.
         * It's impossible to determine whether the query will be successfully cancelled
         * except by watching for a NoticeEvent of type "QUERY CANCELED".
         *
         * @see org.postgresql.ErrorCodes.QUERY_CANCELED
         * @param token QueryToken of query to cancel
         * @return true if an attempt to cancel the query was made
         */
        function cancel(token:QueryToken):Boolean
    }
}