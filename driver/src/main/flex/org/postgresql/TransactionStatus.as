package org.postgresql {

    public class TransactionStatus {
        public static const IDLE:String = 'I';
        public static const IN_TRANSACTION_BLOCK:String = 'T';
        public static const IN_TRANSACTION_ERROR:String = 'E';
    }
}