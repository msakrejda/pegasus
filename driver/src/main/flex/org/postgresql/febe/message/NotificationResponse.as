package org.postgresql.febe.message {

	import org.postgresql.io.ICDataInput;

	public class NotificationResponse extends AbstractMessage implements IBEMessage {

        public var notifierPid:int;
        public var condition:String;
        public var auxinfo:String;

		public function read(input:ICDataInput):void {
			notifierPid = input.readInt();
			condition = input.readCString();
			auxinfo = input.readCString();
		}

	}
}