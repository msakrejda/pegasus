package org.postgresql.febe.message
{
    import flash.utils.IDataOutput;

    public class Query extends AbstractMessage implements IFEMessage
    {
        public var query:String;
        public function Query(query:String) {
            this.query = query;
        }
        
        public function write(out:IDataOutput):void {
            out.writeByte(code('Q'));
            var len:int = query.length + 1 + 4;
            out.writeInt(len);
            writeCString(query);
        }        
    }
}