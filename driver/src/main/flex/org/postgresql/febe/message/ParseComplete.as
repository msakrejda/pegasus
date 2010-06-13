package org.postgresql.febe.message {

    import org.postgresql.io.ICDataInput;

    public class ParseComplete extends AbstractMessage implements IBEMessage {

        public function read(input:ICDataInput):void {
            // do nothing
        }
        
    }
}