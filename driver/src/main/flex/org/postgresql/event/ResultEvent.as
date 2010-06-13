package org.postgresql.event {

	import flash.events.Event;

	public class ResultEvent extends Event {

        public static const RESULT:String = 'result'; 

		public var affectedRows:int;
		public var insertOid:int;

		public function ResultEvent(type:String, affected:int, oid:int) {
			super(type);
			this.insertOid = oid;
			this.affectedRows = affected;
		}
	}
}