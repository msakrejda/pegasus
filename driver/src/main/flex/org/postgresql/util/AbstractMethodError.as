package org.postgresql.util {

    /**
     * Error indicating that an abstract method has been invoked without being overridden
     * by a subclass. ActionScript does not have true abstract classes; this is used to
     * emulate that behavior at runtime.
     */
    public class AbstractMethodError extends Error {

        /**
         * @private
         */
        public function AbstractMethodError() {
            super("This method must be implemented by the subclass");
        }

    }
}