package org.postgresql.febe.message {

    import org.postgresql.febe.message.IBEMessage;
    import org.postgresql.io.ICDataInput;

    public class NoticeResponse extends AbstractInfoMessage implements IBEMessage {

        public override function read(input:ICDataInput):void {
            super.read(input);
        }
        
    }
}