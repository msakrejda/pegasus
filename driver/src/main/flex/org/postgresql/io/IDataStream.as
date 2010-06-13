package org.postgresql.io {

    import flash.events.IEventDispatcher;

    /**
     * Defines a binary communication channel. Data can be written to the stream
     * or read from the stream. When new data is available, the stream must dispatch
     * the DataStreamEvent.PROGRESS Event to notify clients.
     * <br/>
     * Note also that an IDataStream always connects automatically, and cannot be
     * reconnected once disconnected. If you need finer control over connectivity,
     * it should be wrapped in a factory or pool. 
     */
    public interface IDataStream extends ICDataInput, ICDataOutput, IEventDispatcher {
        function flush():void;
        function close():void;
        function get connected():Boolean;
    }
}