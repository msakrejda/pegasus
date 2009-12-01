package org.postgresql.util {

    public class Debugging {
        // TODO: we should be able to define this as a function instead
        // of a static method. For some reason, FlexBuilder does not like
        // this.
        public static function assert(msg:String, expression:*):void {
            if (!expression) {
                throw new ("Assertion failure: " + msg);
            }
        }
    }
}