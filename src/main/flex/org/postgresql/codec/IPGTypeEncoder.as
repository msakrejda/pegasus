package org.postgresql.codec {

    import org.postgresql.io.ICDataOutput;

    public interface IPGTypeEncoder {
        function encode(stream:ICDataOutput, format:int, value:Object):void;
    }
}