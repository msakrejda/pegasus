package org.postgresql.febe.message {

    import flash.utils.ByteArray;
    import org.postgresql.io.ICDataOutput;

    public class Bind extends AbstractMessage implements IFEMessage {

        public var portal:String;
        public var statement:String;
        public var formats:Array;
        public var parameters:Array;
        public var resultFormats:Array;

        public function write(out:ICDataOutput):void {
            var len:int = portal.length + 1 + statement.length + 1 + 2 + (2 * formats.length) + 2;
            for each (var param:ByteArray in parameters) {
                len += 4 + param.length;
            }
            len += 2 + (2 * resultFormats.length);
            out.writeByte(code('B'));
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