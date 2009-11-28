package org.postgresql.febe.message {

    import org.postgresql.febe.message.AbstractMessage;
    import org.postgresql.febe.message.IBEMessage;
    import org.postgresql.io.ICDataInput;
    
    public class BackendKeyData extends AbstractMessage implements IBEMessage {

        public var pid:int;
        public var key:int;

        public function read(input:ICDataInput):void {
            pid = input.readInt();
            key = input.readInt();
        }
        
    }
}