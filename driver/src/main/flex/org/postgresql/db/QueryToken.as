package org.postgresql.db {

	public class QueryToken {

		private var _sql:String;

		public function QueryToken(sql:String) {
			_sql = sql;
		}

		public function get sql():String {
			return _sql;
		}

	}
}