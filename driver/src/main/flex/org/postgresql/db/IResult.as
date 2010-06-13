package org.postgresql.db {
	import flash.events.IEventDispatcher;
	
	// dispatches events for result, error, and notice
	public interface IResult extends IEventDispatcher {
		function get affectedRows():int;
        function get insertOid():int;
	}
}