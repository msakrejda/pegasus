package org.postgresql.febe.message {

    import org.postgresql.febe.message.AbstractMessage;
    import org.postgresql.febe.message.IFEMessage;
    import org.postgresql.io.ICDataOutput;

    public class PasswordMessage extends AbstractMessage implements IFEMessage {
        private var _password:String;

        public function PasswordMessage(password:String) {
            _password = password;
        }

        public function write(out:ICDataOutput):void {
            out.writeByte(code('p'));
            var len:int = 4 + _password.length + 1;
            out.writeInt(len);
            // Note that for GSSAPI and SSPI, this will not be correct, even though
            // they nominally use the same message type. We may want to add a
            // GSSPasswordMessage pseudo-message to handle that when adding these
            // authentication protocols.
            out.writeCString(_password);
        }

    }
}