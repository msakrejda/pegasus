package org.postgresql {

	/**
	 * Possible values for the current transaction status of the connection. 
	 */
    public class TransactionStatus {
    	/**
    	 * The connection is not in an open transaction.
    	 */
        public static const IDLE:String = 'I';
        /**
         * The connection is in an open transaction.
         */
        public static const IN_TRANSACTION_BLOCK:String = 'T';
        /**
         * The connection is in a failed transaction. The transaction
         * must be rolled back.
         */
        public static const IN_TRANSACTION_ERROR:String = 'E';
    }
}