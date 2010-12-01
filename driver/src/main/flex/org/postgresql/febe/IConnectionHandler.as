package org.postgresql.febe {

    import org.postgresql.CodecError;
    import org.postgresql.ProtocolError;

    /**
     * Provides callbacks for interactions with the PostgreSQL protocol-level
     * connection object. In terms of the interface contract, "query" means
     * any message sent to the server through the basic or extend query protocol. 
     */
    public interface IConnectionHandler {

        /**
         * Indicates a warning or other notice. The connection is still live.
         */
        function handleNotice(fields:Object):void;

        // N.B.: Technically, this is also how the server communicates protocol
        // errors such as "wtf are you talking about, client?" However, if the
        // driver is doing its job, that won't happen, so we will not expose
        // this in the interface
        //
        /**
         * Indicates an SQL or authentication error. The connection may or may
         * not be live. If the connection has been broken, this call will be followed
         * by one of the other calls below, but note that the connection may
         * already be down when this callback is running.
         */
        function handleSQLError(fields:Object):void;

        /**
         * Indicates an error in encoding or decoding. The connection is still live,
         * but the current query has been discarded.
         */
        function handleCodecError(error:CodecError):void;

        /**
         * Indicates an error in the understanding of the protocol between client
         * and server. The connection is broken. 
         */
        function handleProtocolError(error:ProtocolError):void;

        /**
         * Indicates a connectivity error in the underlying stream. The connection
         * is broken.
         */
        function handleStreamError(error:Error):void;

        // TODO: for PG 9+, this can include a (string) payload
        /**
         * Indicates a PostgreSQL LISTEN / NOTIFY notification.
         */
        function handleNotification(condition:String, notifierPid:int):void;

        /**
         * Indicates that a query has finished exeucting and that the underlying
         * connection is ready for another query.
         *
         * @param status the current transaction status
         * @see org.postgresql.TransactionStatus
         */
        function handleReady(status:String):void;

        /**
         * Indicates that the underlying connection has completed the handshake
         * with the backend and the connection is ready for use.
         */
        function handleConnected():void;

        /**
         * Indicates a change to a server parameter. Note that a number of parameter
         * "changes" occur at startup to communicate the server's initial parameter
         * values.
         */
        function handleParameterChange(name:String, newValue:String):void;
    }
}