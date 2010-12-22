package org.postgresql.febe.message {

    import org.postgresql.io.ICDataOutput;

    public class Close extends AbstractMessage implements IFEMessage {

        public var name:String;
        public var kind:String;

        public static const STATEMENT:String = 'S';
        public static const PORTAL:String = 'P';

        public function write(out:ICDataOutput):void {
            out.writeByte(code('C'));
            out.writeInt(4 + 1 + name.length + 1);
            out.writeByte(code(kind));
            out.writeCString(name);
        }

    }
}