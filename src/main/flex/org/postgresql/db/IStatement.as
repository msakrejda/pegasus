package org.postgresql.db {

    import flash.events.IEventDispatcher;

    public interface IStatement extends IEventDispatcher {
        function execute(sql:String):void;
        function close():void;
    }
}