package org.postgresql.febe.message
{
    import flash.utils.IDataOutput;

    public class PasswordMessage extends AbstractMessage implements IFEMessage
    {
        private var _password:String;

        public function PasswordMessage(password:String)
        {
            _password = password;
        }

        public function write(out:IDataOutput):void
        {
            out.write(code('p'));
            var len:int = 4 + _password.length + 1;
            out.writeInt(len);
            writeCString(out, _password);
        }
        
    }
}