package org.postgresql.febe.message {

    import org.postgresql.febe.message.AbstractMessage;
    import org.postgresql.febe.message.IBEMessage;
    import org.postgresql.io.ICDataInput;

    public class ParameterStatus extends AbstractMessage implements IBEMessage {

        public var name:String;
        public var value:String;

        public function read(input:ICDataInput):void {
            name = input.readCString();
            value = input.readCString();
        }

    }
}