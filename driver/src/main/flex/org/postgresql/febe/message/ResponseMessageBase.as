package org.postgresql.febe.message {

    import org.postgresql.NoticeFields;
    import org.postgresql.febe.message.AbstractMessage;
    import org.postgresql.febe.message.IBEMessage;
    import org.postgresql.io.ICDataInput;

    public /* abstract */ class ResponseMessageBase extends AbstractMessage implements IBEMessage {

        public var fields:Object;

        public function read(input:ICDataInput):void {
            fields = {};
            var nextByte:int;
            while ((nextByte = input.readByte()) != 0) {
                var fieldType:String = String.fromCharCode(nextByte);
                fields[fieldType] = input.readCString();
            }
        }

        public function toString():String {
            var items:Array = [];
            for (var key:String in fields) {
                items.push(NoticeFields.describe(key) + ': ' + fields[key]);
            }
            return super.toString() + '[' + items.join(', ') + ']';
        }

    }
}