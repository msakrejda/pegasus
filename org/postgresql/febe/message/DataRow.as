package org.postgresql.febe.message
{
    import flash.utils.ByteArray;
    import flash.utils.IDataInput;
    
    public class DataRow extends AbstractMessage implements IBEMessage
    {
        public var rowBytes:Array;
        public function read(input:IDataInput):void
        {
            rowBytes = [];
            var colCount:int = input.readShort();
            for (var i:int = 0; i < colCount; i++) {
                var fieldByteCount:int = input.readInt();
                var fieldBytes:ByteArray; 
                if (fieldByteCount >= 0) {
                    fieldBytes = new ByteArray();
                    if (fieldByteCount > 0) {
                        input.readBytes(fieldBytes, 0, fieldByteCount);
                    }
                } else {
                    fieldBytes = null;
                }
                rowBytes.push(fieldBytes);
            }
        }
        
    }
}