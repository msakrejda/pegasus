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
            addEventListener(IOErrorEvent.IO_ERROR, handleError);
            addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
            addEventListener(Event.CLOSE, handleError);
        }

        private function handleSocketData(e:ProgressEvent):void {
            dispatchEvent(new DataStreamEvent(DataStreamEvent.PROGRESS));
        }
        
        private function handleError(e:Event):void {
        	if (connected) {
                dispatchEvent(new DataStreamErrorEvent(DataStreamErrorEvent.ERROR));
            }
        }

        public function readCString():String {
            return IOUtil.readCString(this);
        }

        public function writeCString(value:String):void {
            IOUtil.writeCString(this, value);
        }
    }
}