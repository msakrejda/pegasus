package org.postgresql {

	public class CodecError extends Error {

		public static const ENCODE:String = 'encode';
		public static const DECODE:String = 'decode';

		public var direction:String;
		public var oid:int;
		public var as3Type:Class;

		public function CodecError(message:String, direction:String, oid:int=Oid.UNSPECIFIED, as3Type:Class=null) {
			super(message);
			this.direction = direction;
			this.oid = oid;
			this.as3Type = as3Type;
		}
		
	}
}