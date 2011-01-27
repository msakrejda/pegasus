package org.postgresql.util {

    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    /**
     * Determine the type of the given Object. Note that at the moment, due to some
     * Flash Player shenanigans, this does not work well with numeric types (int, uint, and Number).
     * @param value Object whose class to determine; must not be null
     * @return Class of the given object
     */
    public function getType(value:Object):Class {
        if (value == null) {
            throw new ArgumentError("Cannot determine type of null value");
        } else if (value is XMLList || value is XML) {
            // Note that XMLList and XML don't play nice with .constructor. There's odd
            // behavior with numeric types as well, but that seems more difficult to
            // work around. Will revisit.
            var fqcn:String = getQualifiedClassName(value);
            return Class(getDefinitionByName(fqcn));
        } else {
            return Class(value.constructor);
        }
    }

}
