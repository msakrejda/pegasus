package org.postgresql.io {

    import flash.utils.IDataOutput;

    public interface ICDataOutput extends IDataOutput {
        function writeCString(str:String):void;
    }
}