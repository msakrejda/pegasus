package org.postgresql.io {

    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.Socket;

    public class SocketDataStream extends Socket implements IDataStream {

        public function SocketDataStream(host:String, port:int) {
            super(host, port);
            addEventListener(ProgressEvent.SOCKET_DATA, handleSocketData);
            addEventListener(IOErrorEvent.IO_ERROR, handleDisconnected);
            addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleDisconnected);
        }

        private function handleSocketData(e:ProgressEvent):void {
        	dispatchEvent(new DataStreamEvent(DataStreamEvent.PROGRESS));
        }
        
        private function handleDisconnected(e:Event):void {
        	dispatchEvent(new DataStreamEvent(DataStreamEvent.DISCONNECTED));
        }

        public function readCString():String {
            return IOUtil.readCString(this);
        }

        public function writeCString(value:String):void {
            IOUtil.writeCString(this, value);
        }
    }
}