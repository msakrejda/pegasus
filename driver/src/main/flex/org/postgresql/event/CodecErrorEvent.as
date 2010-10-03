package org.postgresql.event {

	import flash.events.ErrorEvent;
	
	import org.postgresql.CodecError;

	public class CodecErrorEvent extends ErrorEvent {
		
		public static const CODEC_ERROR:String = 'codecError';

		public function CodecErrorEvent(type:String, error:CodecError) {
			super(type, false, false, text);
		}
		
	}
}