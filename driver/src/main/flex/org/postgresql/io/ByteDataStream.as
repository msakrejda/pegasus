package org.postgresql.io {

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.utils.ByteArray;

    /**
     * An <code>IDataStream</code> backed by a ByteArray.
     */
    public class ByteDataStream extends ByteArray implements IDataStream {

        private var _dispatcher:IEventDispatcher;
        private var _connected:Boolean;

        public function ByteDataStream() {
            _dispatcher = new EventDispatcher();
        }

        /**
         * @inheritDoc
         */
        public function readCString():String {
            return IOUtil.readCString(this);
        }

        /**
         * @inheritDoc
         */
        public function writeCString(value:String):void {
            IOUtil.writeCString(this, value);
        }

        /**
         * @inheritDoc
         */
        public function dispatchEvent(event:Event):Boolean {
            return _dispatcher.dispatchEvent(event);
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
        public function flush():void {
            /* do nothing */
            dispatchEvent(new DataStreamEvent(DataStreamEvent.PROGRESS));
        }

        /**
         * @inheritDoc
         */
        public function close():void {
            _connected = false;
        }

        /**
         * @inheritDoc
         */
        public function get connected():Boolean {
            return _connected;
        }

    }
}