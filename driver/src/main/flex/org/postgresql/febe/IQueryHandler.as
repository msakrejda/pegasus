package org.postgresql.febe {

    public interface IQueryHandler {
        /**
         * Handle the FieldDescription metadata relating to this query. This will be called before
         * handleData or handleCompletion.
         *
         * @param fields an array of FieldDescription objects.
         * @throws org.postgresql.CodecError if an no suitable decoder could be found for one or
         *      more of the fields
         */
        function handleMetadata(fields:Array):void;
        /**
         * Handle the data relating to this query. The argument will be an array of an arbitrary
         * number of arrays corresponding to the raw bytes for each field. This method will be called
         * zero or more times before handleCompletion is called.
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
         * Indicates successful completion of a query. After this is
         * called, no other methods on this IQueryHandler will be called.
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