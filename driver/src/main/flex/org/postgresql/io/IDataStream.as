package org.postgresql.io {

    import flash.events.IEventDispatcher;

    // TODO: the IDataStream needs to define CLOSE and ERROR events
    // to be generically useful to the MessageBroker
    public interface IDataStream extends ICDataInput, ICDataOutput, IEventDispatcher {

    }
}