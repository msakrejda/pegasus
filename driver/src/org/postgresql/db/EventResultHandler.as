package org.postgresql.db {

    import org.postgresql.db.event.QueryResultEvent;
    import org.postgresql.db.event.QueryCompletionEvent;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;


    /**
     * Dispatched when a query completes.
     *
     * @eventType org.postgresql.db.event.QueryCompletionEvent
     */
    [Event(name="queryCompletion", type="org.postgresql.db.event.QueryCompletionEvent")]

    /**
     * Dispatched when a query result set is available.
     *
     * @eventType org.postgresql.db.event.QueryResultEvent.RESULT
     */
    [Event(name="queryResult", type="org.postgresql.db.event.QueryResultEvent")]

    /**
     * An <code>IResultHandler</code> which dispatches events when queries complete.
     */
    public class EventResultHandler extends ResultHandlerBase implements IEventDispatcher {

        private var _dispatcher:IEventDispatcher;

        /**
         * @private
         */
        public function EventResultHandler() {
            _dispatcher = new EventDispatcher();
        }

        /**
         * @private
         */
        public override function handleCompletion(command:String, rows:int, oid:int):void {
            if (columns) {
                _dispatcher.dispatchEvent(new QueryResultEvent(QueryResultEvent.RESULT, columns, data));
            }
            _dispatcher.dispatchEvent(new QueryCompletionEvent(QueryCompletionEvent.COMPLETE, command, rows, oid));
        }

        /**
         * @private
         */
        public function dispatchEvent(event:Event):Boolean {
            return _dispatcher.dispatchEvent(event);
        }

        /**
         * @inheritDoc
         */
        public function hasEventListener(type:String):Boolean {
            return _dispatcher.hasEventListener(type);
        }

        /**
         * @inheritDoc
         */
        public function willTrigger(type:String):Boolean {
            return _dispatcher.willTrigger(type);
        }

        /**
         * @inheritDoc
         */
        public function removeEventListener(type:String, listener:Function, useCapture:Boolean=false):void {
            _dispatcher.removeEventListener(type, listener, useCapture);
        }

        /**
         * @inheritDoc
         */
        public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
            _dispatcher.addEventListener(type, listener, useCapture, priority, useWeakReference);
        }
    }
}
