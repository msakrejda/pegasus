package org.postgresql.febe.message {

    import org.postgresql.febe.message.AbstractMessage;
    import org.postgresql.febe.message.IBEMessage;
    import org.postgresql.io.ICDataInput;

    public /* abstract */ class ResponseMessageBase extends AbstractMessage implements IBEMessage {

        public static const fieldDescriptions:Object = {
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

        public static const SEVERITY:String = 'S';
        public static const CODE:String = 'C';
        public static const MESSAGE:String = 'M';
        public static const DETAIL:String = 'D';
        public static const HINT:String = 'H';
        public static const POSITION:String = 'P';
        public static const INTERNAL_POSITION:String = 'p';
        public static const INTERNAL_QUERY:String = 'q';
        public static const WHERE:String = 'W';
        public static const FILE:String = 'F';
        public static const LINE:String = 'L';
        public static const ROUTINE:String = 'R';

        public var fields:Object;

        protected function fromCode(code:int):String {
            return fieldDescriptions[String.fromCharCode(code)];
        }

        public function read(input:ICDataInput):void {
            fields = {};
            var nextByte:int;
            while ((nextByte = input.readByte()) != 0) {
                var fieldType:String = fromCode(nextByte);
                // Ignore unknown field types
                if (fieldType) {
                    fields[fieldType] = input.readCString();
                }
            }
        }

    }
}