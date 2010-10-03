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
         * Indicates a warning not related to a query. The connection is still live.
         * Notices related to queries are instead passed to the current IQueryHandler.
         */
        function handleNotice(fields:Object):void;

        /**
         * Indicates an error not related to a query. The connection is still live.
         * Errors related to queries are instead passed to the current IQueryHandler.
         */
        function handleError(fields:Object):void;

        function handleProtocolError(error:ProtocolError):void;

		function handleCodecError(error:CodecError):void;

		// TODO: for PG 9+, this can include a (string) payload
		/**
		 * Indicates a PostgreSQL LISTEN / NOTIFY notification.
		 */
        function handleNotification(condition:String, notifierPid:int):void;

		/**
		 * Indicates that a query has finished exeucting and that the underlying
		 * connection is ready for another query.
		 */
        function handleRfq():void;

		/**
		 * Indicates that the underlying connection has completed the handshake
		 * with the backend.
		 */
        function handleConnected():void;

        function handleDisconnected():void;

        function handleParameterChange(name:String, newValue:Object):void;
    }
}