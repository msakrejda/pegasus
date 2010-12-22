package org.postgresql.febe.message {

    import org.postgresql.io.ICDataOutput;

    public class Parse extends AbstractMessage implements IFEMessage {

        public var statement:String;
        public var sql:String;
        public var paramOids:Array;

        public function write(out:ICDataOutput):void {
            var len:int = 4 + statement.length + 1 + sql.length + 1 + 4 * paramOids.length;
            out.writeByte(code('P'));
            out.writeByte(len);
            out.writeCString(statement);
            out.writeCString(sql);
            out.writeShort(paramOids.length);
            for each (var oid:int in paramOids) {
                out.writeInt(oid);
            }
        }

    }
}