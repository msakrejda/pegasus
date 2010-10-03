package org.postgresql.util {

    public function getType(value:Object):Class {
        // TODO: the logic here is wrong. The SwifSuspenders DI container includes
        // proper logic, which has more sensible handling for int, uint, and XML
        if (value == null) {
            throw new ArgumentError("Cannot determine type of null value");
        }
        if (value is int) {
            return int;
        } else if (value is uint) {
            return uint;
        } else {
            return value.constructor;
        }
    }

}
