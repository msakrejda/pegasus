package org.postgresql.util {

    /**
     * Assert an expected program invariant by verifying that the given expression
     * evaluates to true. Throw an AssertionError with the given message if the assertion
     * fails. Note that assert is a regular function, so the expression is evaluated
     * before being passed to <code>assert</code>. Most notably, this means that the
     * expression itself cannot be printed (unless it's duplicated in the message),
     * and it will be evaluated even when running in release mode.
     *
     * @param msg failure message
     * @param expression expression to evaluate
     * @see org.postgresql.util.AssertionError
     */
    public function assert(msg:String, expression:*=false):void {
        if (!expression) {
            throw new AssertionError(msg);
        }
    }

}