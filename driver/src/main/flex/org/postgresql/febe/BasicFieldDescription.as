package org.postgresql.febe {

	public class BasicFieldDescription implements IFieldInfo {

		public var typeOid:int;
		public var format:int;

		public function BasicFieldDescription(oid:int, format:int) {
            this.oid = oid;
            this.format = format;
		}

	}
}