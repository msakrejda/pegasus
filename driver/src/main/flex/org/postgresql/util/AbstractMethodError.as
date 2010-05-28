package org.postgresql.util {

	public class AbstractMethodError extends Error {

		public function AbstractMethodError() {
			super("This method must be implemented by the subclass");
		}

	}
}