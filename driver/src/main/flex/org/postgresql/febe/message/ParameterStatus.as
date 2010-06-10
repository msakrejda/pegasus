package org.postgresql.febe.message {

    import org.postgresql.io.ICDataInput;
    import org.postgresql.util.format;

    public class ParameterStatus extends AbstractMessage implements IBEMessage {

        public var name:String;
        public var value:String;

        public function read(input:ICDataInput):void {
            name = input.readCString();
            value = input.readCString();
        }

        public override function toString():String {
            return format("{0} {{1} : {2}}", type, name, value);
        }
    }
}