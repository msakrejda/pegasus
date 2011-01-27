package org.postgresql.io {

    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.Socket;

    /**
     * A <code>Socket</code>-based implementation of IDataStream. The Socket
     * is connected immediately, and in normal operation, the server is
     * never expected to close the connection, so a simple close is considered
     * an error unless initiated by the client.
     *
     * @see flash.net.Socket
     */
    public class SocketDataStream extends Socket implements IDataStream {

        private var _clientDisconnect:Boolean;

        /**
         * Create a new stream connecting to given host and port
         *
         * @param host host to connect to
         * @param port port to connect to
         */
        public function SocketDataStream(host:String, port:int) {
            super(host, port);
            // TODO: Technically, if SocketDataStream "is a" socket, we should
            // support reconnect. Since we'll only be using it through the
            // IDataStream interface, we can be a little lazy here...
            _clientDisconnect = false;
            addEventListener(ProgressEvent.SOCKET_DATA, handleSocketData);
            addEventListener(IOErrorEvent.IO_ERROR, handleError);
            addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
            addEventListener(Event.CLOSE, handleClose);
        }

        private function handleSocketData(e:ProgressEvent):void {
            if (connected) {
                dispatchEvent(new DataStreamEvent(DataStreamEvent.PROGRESS));
            }
        }

        private function handleError(e:ErrorEvent):void {
            dispatchEvent(new DataStreamErrorEvent(DataStreamErrorEvent.ERROR, e.text));
        }

        private function handleClose(e:Event):void {
            if (!_clientDisconnect) {
                dispatchEvent(new DataStreamErrorEvent(DataStreamErrorEvent.ERROR, "Unexpected close of stream by server"));
            }
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
        public override function close():void {
            _clientDisconnect = true;
            super.close();
        }
    }
}