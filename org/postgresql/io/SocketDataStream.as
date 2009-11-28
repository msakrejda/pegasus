package org.postgresql.io {

    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.net.Socket;

    import org.postgresql.io.IOUtil;

    public class SocketDataStream extends Socket implements IDataStream {

        // TODO: pull out into DataStreamEvent class
        public static const DATA_AVAILABLE:String = 'dataAvailable';

        public function SocketDataStream(host:String=null, port:int=0) {
            super(host, port);
            super.addEventListener(ProgressEvent.SOCKET_DATA, handleSocketData);
        }

        private function handleSocketData(e:ProgressEvent):void {
            super.dispatchEvent(new Event(DATA_AVAILABLE));
        }

        public function readCString():String {
            return IOUtil.readCString(this);
        }

        public function writeCString(value:String):void {
            IOUtil.writeCString(this, value);
        }

    }
}