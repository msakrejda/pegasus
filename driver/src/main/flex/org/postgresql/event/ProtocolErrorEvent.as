package org.postgresql.event {

	import flash.events.ErrorEvent;
	
	import org.postgresql.ProtocolError;

	public class ProtocolErrorEvent extends ErrorEvent {
		
		public static const PROTOCOL_ERROR:String = 'protocolError';
		
		public function ProtocolErrorEvent(type:String, error:ProtocolError) {
			super(type, false, false, text);
		}
		
	}
}