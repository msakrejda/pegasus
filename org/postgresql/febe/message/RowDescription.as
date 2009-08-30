package org.postgresql.febe.message
{
    import flash.utils.IDataInput;
    
    public class RowDescription extends AbstractMessage implements IBEMessage
    {
        public final const FORMAT_TEXT:int = 0x00;
        public final const FORMAT_BINARY:int = 0x01;

        public var rows:Array;
        public function read(input:IDataInput):void
        {
            rows = [];
            var numFields:int = input.readShort();
            for (var i:int = 0; i < numFields; i++) {
                var field:FieldDescription = new FieldDescription();
                field.name = readCString(input);
                field.tableOid = input.readInt();
                field.attributeNum = input.readShort();
                field.typeOid = input.readInt();
                field.size = input.readShort();
                field.typeModifier = input.readInt();
                field.format = input.readShort();
            }
            
        }
        
    }
}