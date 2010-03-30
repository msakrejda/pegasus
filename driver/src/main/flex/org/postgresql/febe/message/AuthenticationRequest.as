package org.postgresql.febe.message {

    import flash.utils.ByteArray;

    import org.postgresql.febe.message.AbstractMessage;
    import org.postgresql.febe.message.IBEMessage;
    import org.postgresql.febe.message.MessageError;
    import org.postgresql.io.ICDataInput;

    /**
     * An ugly conglomeration of all the different AuthenticationRequest subtypes.
     * This is not pretty, but all the different subtypes are very similar, and
     * all share the same message type. It's easier to deal with it like this.
     */
    public class AuthenticationRequest extends AbstractMessage implements IBEMessage {

        public var auxdata:ByteArray;
        public var subtype:int;

        public static const subtypes:Object = {
            (int.MIN_VALUE): 'Abstract',
            0: 'Ok',
            2: 'KerberosV5',
            3: 'CleartextPassword',
            5: 'MD5Password',
            6: 'SCMCredential',
            7: 'GSS',
            9: 'SSPI',
            8: 'GSSContinue'
        };

        public static const OK:int = 0;
        public static const KERBEROS_V5:int = 2;
        public static const CLEARTEXT_PASSWORD:int = 3;
        public static const MD5_PASSWORD:int = 5;
        public static const SCM_CREDENTIAL:int = 6;
        public static const GSS:int = 7;
        public static const SSPI:int = 9;
        public static const GSS_CONTINUE:int = 8;

        public function AuthenticationRequest() {
            auxdata = new ByteArray();
            subtype = int.MIN_VALUE;
        }

        public override function get type():String {
            return 'Authentication' + subtypes[subtype];
        }

        public function read(input:ICDataInput):void {
            subtype = input.readInt();
            if (!(subtype in subtypes)) {
                throw new MessageError("Unexpected AuthenticationRequest type: " + subtype, this);
            }
            if (subtype == MD5_PASSWORD || subtype == GSS_CONTINUE) {
                input.readBytes(auxdata, input.bytesAvailable);
            }
        }

    }
}