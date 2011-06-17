package org.postgresql.febe {
    import org.postgresql.febe.IQueryHandler;

    public interface IExtendedQueryHandler extends IQueryHandler {
        /**
         * For each argument, provide an <code>ArgumentInfo</code> object defining
         * encoding format of the argument value, the intended PostgreSQL oid, and
         * encoded argument value.
         *
         * @param args argument values to describe (note that some may be <code>null</code>)
         * @param serverParameters values of server parameters at the time
         * @return the corresponding argument descriptions
         * @see org.postgresql.febe.ArgumentInfo
         */
        function describeArguments(args:Array, serverParameters:Object):Array;
        /**
         * Specify which encoding format(s) should be used to return the results
         * of the given query (if any). The descriptions of the query fields may
         * be passed to this function, if available.
         * <p/>
         * If field description metadata is not available at the time this function
         * is called, <code>null</code> will be passed in, and this function must
         * still specify valid encoding formats.
         * <p/>
         * Note that either the number of formats returned must equal the number of
         * field descriptions passed in, or a single format to be used for all fields
         * must be returned as a one-element <code>Array</code>.
         * <p/>
         * Note: since the number of result fields is not known ahead of time when
         * field metadata is not yet available, this method should typically return
         * a single format for all fields in these cases (otherwise, the correct
         * number of fields must still be provided).
         *
         * @param fieldDescriptions an <code>Array</code> of <code>IFieldInfo</code>, or
         *     <code>null</code> if not available
         * @return an <code>Array</code> of <code>int</code>s corresponding defining
         *     the encoding format(s) to use for the results, or containing a single
         *     format code to use for all result columns
         * @see org.postgresql.EncodingFormat
         * @see org.postgresql.febe.IFieldInfo
         */
        function getOutputFormats(fieldDescriptions:Array):Array;

    }
}
