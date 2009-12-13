package org.postgresql.util {

    public function getType(value:Object):Object {
        if (value == null) {
            throw new ArgumentError("Cannot determine type of null value");
        }
        // Note that since the int class is a low-level primitive
        // in ActionScript, it has some weird behaviors. Namely,
        // Object(42).constructor == Number, not int. Therefore,
        // we check the type before returning the class.
        return value is int ? int : value.constructor;
    }

}
