package org.postgresql.db {

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
     * Represents a single connection to a PostgreSQL backend.
     */
    public interface IConnection {
        /**
         * Create a simple (unparameterizable) statement tied to this connection.
         * Execution of multiple statements tied to the same connection is queued.
         */
        function createStatement():IStatement;
        /**
         * Close the connection. This cleans up any outstanding resources related
         * to the connection. Note that a closed connection cannot be reopened.
         * 
         * It is safe (albeit pointless) to call close multiple times. 
         */
        function close():void;
    }
}