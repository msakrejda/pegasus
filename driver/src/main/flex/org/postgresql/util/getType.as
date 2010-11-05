package org.postgresql.util {

    public function getType(value:Object):Class {
        if (value == null) {
            throw new ArgumentError("Cannot determine type of null value");
        }
        if (value is int) {
            return int;
        } else if (value is uint) {
            return uint;
        } else {
            return Class(value.constructor);
        }
    }

}
