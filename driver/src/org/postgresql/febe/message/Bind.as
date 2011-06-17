package org.postgresql.febe.message {

    import flash.utils.ByteArray;
    import org.postgresql.io.ICDataOutput;

    public class Bind extends AbstractMessage implements IFEMessage {

        public var portal:String;
        public var statement:String;
        public var formats:Array;
        public var parameters:Array;
        public var resultFormats:Array;

        public function Bind(portal:String, statement:String, formats:Array, parameters:Array, resultFormats:Array) {
            this.portal = portal;
            this.statement = statement;
            this.formats = formats;
            this.parameters = parameters;
            this.resultFormats = resultFormats;
        }

        public function write(out:ICDataOutput):void {
            out.writeByte(code('B'));
            var len:int = 4 + portal.length + 1 + statement.length + 1 + 2 + (2 * formats.length) + 2;
            for each (var param:ByteArray in parameters) {
                if (param) {
                    len += 4 + param.length;
                } else {
                    len += 4;
                }
            }
            len += 2 + (2 * resultFormats.length);
            out.writeInt(len);
            out.writeCString(portal);
            out.writeCString(statement);
            out.writeShort(formats.length);
            for each (var format:int in formats) {
                out.writeShort(format);
            }
            out.writeShort(parameters.length);
            for each (var parameter:ByteArray in parameters) {
                if (parameter) {
                    out.writeInt(parameter.length);
                    // TODO: is this the right place to reset this?
                    parameter.position = 0;
                    out.writeBytes(parameter);
                } else {
                    out.writeInt(-1);
                }
            }
            out.writeShort(resultFormats.length);
            for each (var resultFormat:int in resultFormats) {
                out.writeShort(resultFormat);
            }

        }

    }
}