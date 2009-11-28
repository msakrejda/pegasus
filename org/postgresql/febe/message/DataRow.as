package org.postgresql.febe.message {

    import flash.utils.ByteArray;
    
    import org.postgresql.febe.message.AbstractMessage;
    import org.postgresql.febe.message.IBEMessage;
    import org.postgresql.io.ICDataInput;

    public class DataRow extends AbstractMessage implements IBEMessage {

        // TODO: encapsulating this better may allow us better
        // performance here--if we can store the entire row data
        // as a single byte array, we can still provide deserialization
        // access to it field-by-field
        public var rowBytes:Array;

        public function read(input:ICDataInput):void {
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