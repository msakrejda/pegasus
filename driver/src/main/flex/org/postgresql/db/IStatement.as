package org.postgresql.db {

    import flash.events.IEventDispatcher;

    public interface IStatement extends IEventDispatcher {
        function executeQuery(sql:String):IResultSet;
        function executeUpdate(sql:String):IResult;
        // Note that cancel at the statement level gives us interesting
        // (and possibly unwanted) coarse-grained behavior, since there
        // may be a number of possible outstanding statement executions
        // at any one time
        function cancel():void;
        function close():void;
    }
}