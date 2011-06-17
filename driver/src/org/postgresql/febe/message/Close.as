package org.postgresql.febe.message {

    import org.postgresql.io.ICDataOutput;

    public class Close extends AbstractMessage implements IFEMessage {

        public static const PORTAL:String = 'P';
        public static const STATEMENT:String = 'S';

        public var kind:String;
        public var name:String;

        public function Close(kind:String, name:String) {
            if (kind != PORTAL && kind != STATEMENT) {
                throw new ArgumentError("Unknown close kind for " + name + ": " + kind);
            }
            this.kind = kind;
            this.name = name;
        }

        public function write(out:ICDataOutput):void {
            out.writeByte(code('C'));
            out.writeInt(4 + 1 + name.length + 1);
            out.writeByte(code(kind));
            out.writeCString(name);
        }

    }
}