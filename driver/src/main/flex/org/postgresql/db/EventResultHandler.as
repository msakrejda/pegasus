package org.postgresql.db {

    import org.postgresql.db.event.QueryResultEvent;
    import org.postgresql.db.event.QueryCompletionEvent;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;

    public class EventResultHandler extends ResultHandlerBase implements IEventDispatcher {

		private var _dispatcher:IEventDispatcher;

		public function EventResultHandler() {
			_dispatcher = new EventDispatcher();
		}

        public override function handleCompletion(command:String, rows:int, oid:int):void {
            if (columns) {
                _dispatcher.dispatchEvent(new QueryResultEvent(QueryResultEvent.RESULT, columns, data));
            }
            _dispatcher.dispatchEvent(new QueryCompletionEvent(QueryCompletionEvent.COMPLETE, command, rows, oid));
        }

        public function dispatchEvent(event:Event):Boolean {
            return _dispatcher.dispatchEvent(event);
        }

        public function hasEventListener(type:String):Boolean {
            return _dispatcher.hasEventListener(type);
        }

        public function willTrigger(type:String):Boolean {
            return _dispatcher.willTrigger(type);
        }

        public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
            _dispatcher.removeEventListener(type, listener, useCapture);
        }

        public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
            _dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }
    }
}
