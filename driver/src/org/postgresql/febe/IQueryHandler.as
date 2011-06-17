package org.postgresql.febe {

    /**
     * This interface defines how to consumer query results from the low-level <code>FEBEConnection</code>.
     * The raw protocol-level column metadata is passed to this handler, followed by the raw, un-decoded
     * query results. Note that for queries which do not return any results, the <code>handleMetadata</code>
     * and <code>handleData</code> methods will not be called.
     * @see org.postgresql.febe.FEBEConnection
     */
    public interface IQueryHandler {
        /**
         * Handle the <code>FieldDescription</code> metadata relating to this query. This will be called before
         * handleData or handleCompletion. Note that this may be called multiple times if a query
         * returns multiple result sets.
         *
         * @param fields an array of <code>FieldDescription</code> objects.
         * @throws org.postgresql.CodecError if an no suitable decoder could be found for one or
         *      more of the fields
         * @see org.postgresql.febe.FieldDescription
         */
        function handleMetadata(fields:Array):void;
        /**
         * Handle the data relating to this query. The argument will be an array of an arbitrary
         * number of arrays corresponding to the raw bytes for each field. This method will be called
         * zero or more times after each call to <code>handleMetadata</code> before
         * <code>handleCompletion</code> is called.
         * <br/>
         * Note that some server parameters, such as <code>DateStyle</code>, can affect the decoding
         * process.
         *
         * @param rows
         * @param serverParams
         * @throws org.postgresql.CodecError if an error occurred in decoding data
         */
        function handleData(rows:Array, serverParams:Object):void;
        /**
         * Indicates successful completion of a query. After this is called, no other methods on this
         * IQueryHandler will be called.
         *
         * @param command
         * @param affected
         * @param oid
         */
        function handleCompletion(command:String, affected:int=0, oid:int=-1):void;
        /**
         * Clean up resources associated with this query handler.
         */
        function dispose():void;
    }
}