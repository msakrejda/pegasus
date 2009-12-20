package org.postgresql.util {

    public function assert(msg:String, expression:*=false):void {
        if (!expression) {
            throw new ("Assertion failure: " + msg);
        }
    }

}