package org.postgresql.util {

	public class AssertionError extends Error {

		public function AssertionError(message:String="") {
			super("Assertion failure: " + message);
		}
		
	}
}