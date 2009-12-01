package org.postgresql.io {

    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.net.Socket;

    public class SocketDataStream extends Socket implements IDataStream {

        // TODO: pull out into DataStreamEvent class
        public static const DATA_AVAILABLE:String = ProgressEvent.SOCKET_DATA;

        public function SocketDataStream(host:String=null, port:int=0) {
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