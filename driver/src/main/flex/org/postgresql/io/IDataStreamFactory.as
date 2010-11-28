package org.postgresql.io {

    /**
     * Factory for creating multiple <code>IDataStream</code> instances
     * with the same credentials and initialization.
     */
    public interface IDataStreamFactory {
        /**
         * Create a new IDataStream according to the factory's
         * pre-configured settings.
         *
         * @return the IDataStream created
         */
        function create():IDataStream;
    }
}