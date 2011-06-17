package org.postgresql.util {

    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

    /**
     * Determine the type of the given <code>Object</code>. Note that at the moment, due to some
     * Flash Player shenanigans, this does not work well with numeric types (<code>int</code>,
     * <code>uint</code>, and <code>Number</code>). We take the pragmatic approach that anything
     * numeric that fits in 32 bits and is integral is an <code>int</code>, and all other numeric
     * values are considered <code>Number</code>.
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
        } else if (value is int) {
            return int;
        } else {
            return Class(value.constructor);
        }
    }

}
