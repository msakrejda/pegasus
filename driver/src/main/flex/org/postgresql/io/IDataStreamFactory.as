package org.postgresql.io {

    public interface IDataStreamFactory {
        function create():IDataStream;
    }
}