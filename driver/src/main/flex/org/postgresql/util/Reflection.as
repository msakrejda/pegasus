package org.postgresql.util {

    public class Reflection {

        public static function getType(value:Object):Object {
            // TODO: we may want to relax this...
            if (value == null) {
                throw new ArgumentError("Cannot get type of null value");
            }
            return value is int ? int : value.constructor;
        }

    }
}