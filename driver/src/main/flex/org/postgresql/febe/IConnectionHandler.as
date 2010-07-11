package org.postgresql.febe {
    public interface IConnectionHandler {
        /**
         * Indicates a warning not related to a query. The connection is still live.
         */
        function handleNotice(fields:Object):void;
        /**
         * Indicates an error not related to a query. The connection is still live.
         */
        function handleError(fields:Object):void;

        function handleNotification(condition:String, notifierPid:int):void;
        
        function handleRfq():void;

        function handleConnected():void;

        function handleDisconnected():void;

        function handleParameterChange(name:String, newValue:Object):void;
    }
}