package org.postgresql.febe.message {

    import org.postgresql.febe.message.AbstractMessage;
    import org.postgresql.febe.message.IFEMessage;
    import org.postgresql.io.ICDataOutput;

    public class Query extends AbstractMessage implements IFEMessage {

        public var query:String;

        public function Query(query:String) {
            this.query = query;
        }

        public function write(out:ICDataOutput):void {
            out.writeByte(code('Q'));
            var len:int = query.length + 1 + 4;
            out.writeInt(len);
            out.writeCString(query);
        }        
    }
}