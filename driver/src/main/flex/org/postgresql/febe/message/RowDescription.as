package org.postgresql.febe.message {

    import org.postgresql.io.ICDataInput;

    public class RowDescription extends AbstractMessage implements IBEMessage {

        public var fields:Array;

        public function read(input:ICDataInput):void {
            fields = [];
            var numFields:int = input.readShort();
            for (var i:int = 0; i < numFields; i++) {
                var field:FieldDescription = new FieldDescription();
                try {
                    field.read(input);
                } catch (e:ArgumentError) {
                    throw new MessageError(e.message, this);
                }
                fields.push(field);
            }
        }

    }
}