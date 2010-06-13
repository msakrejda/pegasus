package org.postgresql.db {
	import flash.events.EventDispatcher;
	
	import org.postgresql.event.NoticeEvent;

	internal class ResultBase extends EventDispatcher {
		private var _stmt:IStatement

		public function ResultBase(stmt:IStatement) {
			_stmt = stmt;
		}
		
		public function get statement():IStatement {
			return _stmt;
		}

		public function handleNotice(fields:Object):void {
			dispatchEvent(new NoticeEvent(NoticeEvent.NOTICE, fields));
		}
	
		public function handleError(fields:Object):void {
			dispatchEvent(new NoticeEvent(NoticeEvent.ERROR, fields));
		}
	}
}