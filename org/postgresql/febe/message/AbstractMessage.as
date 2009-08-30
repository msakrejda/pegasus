package org.postgresql.febe.message
{
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    
    public class AbstractMessage implements IMessage
    {
        /**
         * This returns the unqualified class name; we
         * name our messages using FEBE message names,
         * so this corresponds to the official messages names
         */
        public function get type():String {
            var classStr:String = String(Object(this).constructor);
            return classStr.replace(/\[class (\w+)\]/, '$1');
        }
        
        public function toString():String {
            return type;
        }
        
        protected function code(str:String):Number {
            if (str.length > 1) {
                throw new Error("Expected single character, got " + str);
            } else {
                return str.charCodeAt(0);
            }
        }
        
        protected function readCString(input:IDataInput):String {
            var strBytes:Array = [];
            var currByte:int;
            while ((currByte = input.readByte()) != 0) {
                strBytes.push(currByte);
            }
            return String.fromCharCode.apply(null, strBytes);
        }
        
        protected function writeCString(out:IDataOutput, str:String):void {
            out.writeUTFBytes(str);
            out.writeByte(0x00);
        }
    }
    
}