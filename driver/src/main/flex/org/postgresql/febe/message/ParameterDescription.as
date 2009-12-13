package org.postgresql.febe.message {

	import org.postgresql.io.ICDataInput;

	public class ParameterDescription extends AbstractMessage implements IBEMessage {

        public var types:Array;

		public function read(input:ICDataInput):void {
			types = [];
			var paramCount:int = input.readShort();
			for (var i:int = 0; i < paramCount; i++) {
				types.push(input.readInt());
			}
		}
		
	}
}