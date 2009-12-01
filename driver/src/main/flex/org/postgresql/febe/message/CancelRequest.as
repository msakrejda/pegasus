package org.postgresql.febe.message {

    import org.postgresql.febe.message.AbstractMessage;
    import org.postgresql.febe.message.IFEMessage;
    import org.postgresql.io.ICDataOutput;

    public class CancelRequest extends AbstractMessage implements IFEMessage {

        private static const CANCEL_CODE:int = 80877102;

        private var _pid:int;
        private var _key:int

        public function CancelRequest(pid:int, key:int) {
            _pid = pid;
            _key = key;
        }

        public function write(out:ICDataOutput):void {
            out.writeInt(16);
            out.writeInt(CANCEL_CODE);
            out.writeInt(_pid);
            out.writeInt(_key);
        }

    }
}