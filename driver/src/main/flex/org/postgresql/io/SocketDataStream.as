package org.postgresql.io {

    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.net.Socket;

    public class SocketDataStream extends Socket implements IDataStream {

        // TODO: pull out into DataStreamEvent class. It's also kind of a dirty
        // hack to re-use the same event constant value. Unfortunately, the Socket
        // class doesn't seem to like dispatching another event off itself in the
        // ProgressEvent handler.
        public static const DATA_AVAILABLE:String = ProgressEvent.SOCKET_DATA;

        public function SocketDataStream(host:String, port:int) {
            super(host, port);
        }

        public function readCString():String {
            return IOUtil.readCString(this);
        }

        public function writeCString(value:String):void {
            IOUtil.writeCString(this, value);
        }

    }
}