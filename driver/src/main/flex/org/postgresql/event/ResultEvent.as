package org.postgresql.event {

	import flash.events.Event;

	public class ResultEvent extends Event {

        public static const RESULT:String = 'result'; 

		public var results:Array;

		public function ResultEvent(type:String) {
			super(type);
		}
		
	}
}