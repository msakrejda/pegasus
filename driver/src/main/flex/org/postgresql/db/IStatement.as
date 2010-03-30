package org.postgresql.db {

    import flash.events.IEventDispatcher;

    public interface IStatement extends IEventDispatcher {
        function executeQuery(sql:String):ResultSet;
        function executeUpdate(sql:String):Result;
        function cancel():void;
        function close():void;
    }
}