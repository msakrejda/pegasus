package org.postgresql.febe {

	import flash.events.Event;
	
	import org.postgresql.febe.message.AuthenticationRequest;
	import org.postgresql.febe.message.BackendKeyData;
	import org.postgresql.febe.message.ParameterStatus;
	import org.postgresql.febe.message.ReadyForQuery;
	
	// TODO: this should be internal (to connection?)
	public class AuthenticationHandler extends AbstractFEBEMessageHandler {

        public static const AUTHENTICATED:String = 'authenticated';
        
        public var backendPid:int;
        public var backendKey:int;

        public var serverParams:Object;

        private var _authenticated:Boolean;

        public function AuthenticationHandler() {
        	_handlerMethods[AuthenticationRequest] = handleAuth;
        	_handlerMethods[BackendKeyData] = handleKeyData;
        	_handlerMethods[ParameterStatus] = handleParam;
        	_handlerMethods[ReadyForQuery] = handleInitialRfq;
        	serverParams = {};
    	}

        private function handleAuth(msg:AuthenticationRequest):void {
            if (msg.subtype == AuthenticationRequest.OK) {
                _authenticated = true;            	
            } else {
                throw new ProtocolError("Unsupported authentication type requested");                   
            }
        }

		private function handleKeyData(msg:BackendKeyData):void {
			backendKey = msg.key;
			backendPid = msg.pid;
		}

        private function handleParam(msg:ParameterStatus):void {
        	serverParams[msg.name] = msg.value;
        }

        private function handleInitialRfq(msg:ReadyForQuery):void {
        	if (!_authenticated) {
        		throw new ProtocolError("Unexpected RFQ before authentication");
        	} else {
        	   dispatchEvent(new Event(AUTHENTICATED));
        	}
        }
	}
}