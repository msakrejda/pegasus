package org.postgresql.db {
	public interface IConnection {
		function createStatement():IStatement;
        function close():void;
	}
}