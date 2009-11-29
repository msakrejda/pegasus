package org.postgresql.febe.message {

    import org.postgresql.febe.message.AbstractMessage;
    import org.postgresql.febe.message.IBEMessage;
    import org.postgresql.io.ICDataInput;

    public class NoData extends AbstractMessage implements IBEMessage {

        public function read(input:ICDataInput):void {
            /* do nothing */
        }

    }
}