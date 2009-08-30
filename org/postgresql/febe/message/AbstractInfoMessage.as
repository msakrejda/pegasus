package org.postgresql.febe.message
{
    public /* abstract */ class AbstractInfoMessage extends AbstractMessage implements IBEMessage
    {
        public var fields:Object = {
            S : 'SEVERITY',
            C : 'CODE',
            M : 'MESSAGE',
            D : 'DETAIL',
            H : 'HINT',
            P : 'POSITION',
            p : 'INTERNAL POSITION',
            q : 'INTERNAL QUERY',
            W : 'WHERE',
            F : 'FILE',
            L : 'LINE',
            R : 'ROUTINE'
        };
        
        public var fields:Object;

        protected function fromCode(code:int):String {
            return fields[String.fromCharCode(code)];
        }
        
        public function read(input:IDataInput):void
        {
            fields = {};
            var nextByte:int;
            while ((nextByte = input.readByte()) != 0) {
                var fieldType:String = fromCode(nextByte);
                // Ignore unknown field types
                if (fieldType) {
                    fields[fieldType] = readCString(input);
                }
            }
        }
        
    }
}