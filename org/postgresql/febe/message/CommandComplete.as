package org.postgresql.febe.message
{
    import flash.utils.IDataInput;
    
    public class CommandComplete extends AbstractMessage implements IBEMessage
    {
        public var commandTag:String;
        public var command:String;
        public var oid:int;
        public var affectedRows:int;
        
        private static const INSERT_CMD:RegExp = /INSERT (\d+) (\d+)/;
        private static const COPY_CMD:RegExp = /COPY (\d+)?/;
        private static const OTHER_CMD:RegExp = /(DELETE|UPDATE|MOVE|FETCH) (\d+)/;

        public function read(input:IDataInput):void
        {
            var len:int = input.bytesAvailable;
            commandTag = input.readUTFBytes(len);
            var match:Array;
            if (INSERT_CMD.test(commandTag)) {
                match = commandTag.match(INSERT_CMD);
                if (match.length != 3) {
                     badTag(commandTag);
                }
                command = 'INSERT';
                oid = match[1];
                affectedRows = match[2];
            } else if (OTHER_CMD.test(commandTag)) {
                match = commandTag.match(OTHER_CMD);
                if (match.length != 3) {
                     badTag(commandTag);
                }
                command = match[1];
                affectedRows = match[2];
            } else if (COPY_CMD.test(commandTag)) {
                match = commandTag.match(COPY_CMD);
                if (match.length < 2) {
                     badTag(commandTag);
                }
                command = 'COPY';
                affectedRows = match.length > 1 ? match.length[1] : -1;
            } else {
                badTag(commandTag);
            }
        }
        
        private function badTag(tag:String):void {
            throw new MessageError("Unexpected command tag: " + tag);
        }
        
    }
}