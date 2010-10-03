package org.postgresql {

	/**
	 * Indicates an encoding or decoding error. For communication
	 * with the backend, data must be encoded and decoded according
	 * to the protocol specification. This error indicates a failure
	 * in this process.
	 * <br/>
	 * This error does <em>not</em> break the connection, but it does
	 * cause the current query to fail.
	 */
	public class CodecError extends Error {

		/**
		 * An encoding error.
		 */
		public static const ENCODE:String = 'encode';

		/**
		 * A decoding error.
		 */
		public static const DECODE:String = 'decode';

		/**
		 * Whether encoding or decoding caused the error.
		 * @see #ENCODE
		 * @see #DECODE
		 */
		public var direction:String;

		/**
		 * If applicable, the oid of the destination type (when encoding) or
		 * the source type (when decoding).
		 */
		public var oid:int;

		/**
		 * If applicable, the ActionScript Class of the destination type (when
		 * decoding) or the source type (when encoding).
		 */
		public var as3Type:Class;

		public function CodecError(message:String, direction:String, oid:int=Oid.UNSPECIFIED, as3Type:Class=null) {
			super(message);
			this.direction = direction;
			this.oid = oid;
			this.as3Type = as3Type;
		}
		
	}
}