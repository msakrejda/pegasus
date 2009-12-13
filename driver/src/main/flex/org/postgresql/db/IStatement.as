package org.postgresql.db {

    import flash.events.IEventDispatcher;

    public interface IStatement extends IEventDispatcher {
    	function get columns():Array;
    	// TODO: results in other formats
    	//function get results():Array;
        function execute(sql:String):void;
        function close():void;
    }
}