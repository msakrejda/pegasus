package org.postgresql.db {

	import flash.events.IEventDispatcher;

	public interface IResultSet extends IEventDispatcher {
        function get columns():Array;
		function get data():Array;
		function close():void;
	}
}