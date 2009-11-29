package org.postgresql.febe.message {

    import org.postgresql.io.ICDataInput;

    public class ReadyForQuery extends AbstractMessage implements IBEMessage {

        public static const IDLE:String = 'I';
        public static const IN_TRANSACTION_BLOCK:String = 'T';
        public static const IN_TRANSACTION_ERROR:String = 'E';

        public var status:String;

        public function read(input:ICDataInput):void {
            status = String.fromCharCode(input.readByte());
            if (status != IDLE &&
                status != IN_TRANSACTION_BLOCK &&
                status != IN_TRANSACTION_ERROR) {
                throw new MessageError("Invalid status in ReadyForQuery", this);
            }
        }

        public override function toString():String {
            return type + " {" + status + "}";
        }
    }
}