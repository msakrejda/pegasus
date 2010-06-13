package org.postgresql.io {

    import flash.events.ProgressEvent;
    import flash.net.Socket;

    public class SocketDataStream extends Socket implements IDataStream {

        public function SocketDataStream(host:String, port:int) {
            super(host, port);
            addEventListener(ProgressEvent.SOCKET_DATA, handleSocketData);
        }

        private function handleSocketData(e:ProgressEvent):void {
        	dispatchEvent(new DataStreamEvent(DataStreamEvent.PROGRESS));
        }

        public function readCString():String {
            return IOUtil.readCString(this);
        }

        public function writeCString(value:String):void {
            IOUtil.writeCString(this, value);
        }
    }
}