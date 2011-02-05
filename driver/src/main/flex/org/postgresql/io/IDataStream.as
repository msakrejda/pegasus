package org.postgresql.io {

    import flash.events.IEventDispatcher;

    /**
     * Dispatched when new data is available in the stream.
     *
     * @eventType org.postgresql.io.DataStreamEvent.PROGRESS
     */
    [Event(name="progress", type="org.postgresql.io.DataStreamEvent")]

    /**
     * Dispatched when an error occurs in the stream. After an error occurs,
     * the stream is in a disconnected state (and cannot be reconnected).
     * If ability to reconnect is integral to a client of an <code>IDataStream</code>,
     * an <code>IDataStream</code> factory should be used instead. (In that case,
     * a new stream can be obtained, effectively mimicing reconnection.)
     *
     * @eventType org.postgresql.io.DataStreamErrorEvent.ERROR
     */
    [Event(name="dataStreamError", type="org.postgresql.io.DataStreamErrorEvent")]

    /**
     * Defines a binary communication channel between a client (using this stream)
     * and a server. The client initiates the connection, communicates with the
     * server using an established protocol, and then closes a connection. Data
     * can be written to or read from the stream.
     * <br/>
     * Note that a server is never expected to initiate close-of-stream in normal
     * operation, so no standard "<code>IDataStream</code> closed" event exists. A
     * standard server-initiated disconnection is considered an error. A client-initiated
     * close triggers a best-effort attempt to close the server connection cleanly, but
     * any failures here are ignored.
     * <br/>
     * Note that an <code>IDataStream</code> always connects automatically (technically,
     * the first time the AVM processes network requests after the constructor is
     * called), and cannot be reconnected once disconnected (whether through client
     * code or a server error. If finer control over connectivity is required, a
     * factory should be used.
     */
    public interface IDataStream extends ICDataInput, ICDataOutput, IEventDispatcher {

        /**
         * Flush all pending client writes to the server.
         *
         * @throws flash.utils.Error if the connection is closed or broken
         */
        function flush():void;

        /**
         * Close the connection to the backend.
         *
         * @throws flash.utils.Error if the connection is already closed or broken
         */
        function close():void;

        /**
         * Connection status of stream. Note that a stream can be disconnected either
         * through client action or an error.
         *
         * @returns <code>true</code> if this stream is still connected; <code>false</code> otherwise
         */
        function get connected():Boolean;
    }
}