package org.postgresql.io {

    import flash.utils.IDataInput;

    public interface ICDataInput extends IDataInput {
        function readCString():String;
    }
}