package org.postgresql.pgconsole.view.model {
    import org.postgresql.pgconsole.model.vo.ConnectionAttemptVO;
    import org.postgresql.pgconsole.signal.ConnectSignal;
    import org.postgresql.pgconsole.signal.DisconnectedSignal;
    import org.postgresql.pgconsole.signal.ConnectedSignal;

    public class MainViewPresentationModel {

        [Inject]
        public var connectedSignal:ConnectedSignal;
        [Inject]
        public var disconnectedSignal:DisconnectedSignal;

        [Inject]
        public var connectSignal:ConnectSignal;

        [PostConstruct]
        public function initialize():void {
            connectedSignal.add(onConnected);
            disconnectedSignal.add(onDisconnected);
        }

        private function onDisconnected():void {
            currentState = 'disconnected';
        }

        private function onConnected():void {
            currentState = 'connected';
        }

        [Bindable]
        public var currentState:String;

        public function logIn(host:String, port:uint, db:String, username:String, password:String):void {
            connectSignal.dispatch(new ConnectionAttemptVO(buildUrl(host, port, db), username, password));
        }

        private function buildUrl(host:String, port:uint, db:String):String {
            // TODO: proper validation
            var url:String = 'asdbc:postgresql://' + host + ':' + port + '/' + db;
            trace('Connecting to', url);
            return url;
        }
    }
}
