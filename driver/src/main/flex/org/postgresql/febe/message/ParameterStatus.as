package org.postgresql.febe.message {

    import mx.utils.StringUtil;

    import org.postgresql.io.ICDataInput;

    public class ParameterStatus extends AbstractMessage implements IBEMessage {

        public var name:String;
        public var value:String;

        public function read(input:ICDataInput):void {
            name = input.readCString();
            value = input.readCString();
        }

        public override function toString():String {
            return StringUtil.substitute("{0} {{1} : {2}}", type, name, value);
        }
    }
}