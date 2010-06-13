package org.postgresql.db {

	public interface IResult {
		function get affectedRows():int;
        function get insertOid():int;
	}
}