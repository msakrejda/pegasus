package org.postgresql.febe.message
{
    import flash.utils.IDataInput;

    public class AuthenticationKerberosV5 extends AbstractMessage implements IBEMessage
    {
        public function AuthenticationKerberosV5()
        {
            throw new MessageError("Unsupported message type", this);
        }

        public function read(input:IDataInput):void
        {
            /* do nothing for now */
        }

    }
}