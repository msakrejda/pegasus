package org.postgresql.febe.message {

    import org.postgresql.febe.TransactionStatus;
    import org.postgresql.io.ICDataInput;

    public class ReadyForQuery extends AbstractMessage implements IBEMessage {

        public var status:String;

        public function read(input:ICDataInput):void {
            status = String.fromCharCode(input.readByte());
            if (status != TransactionStatus.IDLE &&
                status != TransactionStatus.IN_TRANSACTION_BLOCK &&
                status != TransactionStatus.IN_TRANSACTION_ERROR) {
                throw new MessageError("Invalid status in ReadyForQuery", this);
            }
        }

        public override function toString():String {
            return type + " {" + status + "}";
        }
    }
}