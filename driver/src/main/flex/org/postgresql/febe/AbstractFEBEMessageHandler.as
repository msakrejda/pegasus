package org.postgresql.febe {

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import org.postgresql.febe.message.IBEMessage;
	

	public class AbstractFEBEMessageHandler extends EventDispatcher implements IFEBEMessageHandler {

        protected var _handlerMethods:Dictionary;

		public function AbstractFEBEMessageHandler() {
			_handlerMethods = new Dictionary();
		}

        public function getCallback(msg:IBEMessage):Function {
        	return _handlerMethods[Object(msg).constructor];
        }
	}
}