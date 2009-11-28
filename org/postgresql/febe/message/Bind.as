package org.postgresql.febe.message {

    import org.postgresql.febe.message.IFEMessage;
    import org.postgresql.febe.message.AbstractMessage;
    import org.postgresql.io.ICDataOutput;

    public class Bind extends AbstractMessage implements IFEMessage {

        public function write(out:ICDataOutput):void {
        }

    }
}