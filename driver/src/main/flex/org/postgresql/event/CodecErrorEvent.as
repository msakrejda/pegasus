package org.postgresql.event {

	import flash.events.ErrorEvent;
	
	import org.postgresql.CodecError;

	/**
	 * Indicates that an encoding or decoding error has occurred asynchronously.
	 */
	public class CodecErrorEvent extends ErrorEvent {

		/**
		 * An encoding or decoding error. The attached error contains more details.
		 *
		 * @eventType codecError
		 */
		public static const CODEC_ERROR:String = 'codecError';

		/**
		 * The error that occurred.
		 */
		public var error:CodecError;

		public function CodecErrorEvent(type:String, error:CodecError) {
			super(type, false, false, text);
			this.error = error;
		}
		
	}
}