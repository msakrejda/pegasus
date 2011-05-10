package org.postgresql.febe.message {

    import org.postgresql.io.ICDataOutput;

    public class Parse extends AbstractMessage implements IFEMessage {

        public var statement:String;
        public var sql:String;
        public var paramOids:Array;

        public function Parse(statement:String, sql:String, paramOids:Array) {
            if (statement == null || sql == null || paramOids == null) {
                throw new ArgumentError("statement, sql, and paramOids must not be null");
            }
            this.statement = statement;
            this.sql = sql;
            this.paramOids = paramOids;
        }

        public function write(out:ICDataOutput):void {
            out.writeByte(code('P'));
            var len:int = 4 + statement.length + 1 + sql.length + 1 + 2 + 4 * paramOids.length;
            out.writeInt(len);
            out.writeCString(statement);
            out.writeCString(sql);
            out.writeShort(paramOids.length);
            for each (var oid:int in paramOids) {
                out.writeInt(oid);
            }
        }

        override public function toString():String {
            return super.toString() + ' {' + (statement.length > 0 ? statement : '[unnamed]: ') +
                sql + '; paramOids[' + paramOids.join(',') + ']}';
        }

    }
}