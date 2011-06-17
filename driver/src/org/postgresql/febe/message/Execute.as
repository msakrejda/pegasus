package org.postgresql.febe.message {

    import org.postgresql.io.ICDataOutput;

    public class Execute extends AbstractMessage implements IFEMessage {

        public var portal:String;
        public var limit:int;

        public function Execute(portal:String, limit:int) {
            this.portal = portal;
            this.limit = limit;
        }

        public function write(out:ICDataOutput):void {
            out.writeByte(code('E'));
            var len:int = 4 + portal.length + 1 + 4;
            out.writeInt(len);
            out.writeCString(portal);
            out.writeInt(limit);
        }

        public override function toString():String {
            return super.toString() + ' {' + portal + (limit > 0 ? ' (fetch' + limit + ')' : '') + '}';
        }

    }
}