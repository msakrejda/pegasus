package org.postgresql.util {

    /**
     * Indicates a violation of some expected program invariant.
     *
     * @see org.postgresql.util.assert
     */
    public class AssertionError extends Error {

        public function AssertionError(message:String="") {
            super("Assertion failure: " + message);
        }
        
    }
}