package org.postgresql.io {

    import flash.events.IEventDispatcher;

    // TODO: the IDataStream needs to define CLOSE, PROGRESS, and ERROR events
    // to be generically useful to the MessageBroker
    public interface IDataStream extends ICDataInput, ICDataOutput, IEventDispatcher {
        // Note that 'connect' is *not* part of the interface here--IDataStreams are
        // assumed to be connected when first handed off to the class that is using
        // them, and, for simplicity, there is no concept of reconnection. The
        // factory can be used instead to get a new stream if necessary.
        function flush():void;
        function close():void;
        function get connected():Boolean;
    }
}