package org.postgresql.util {

    import flash.utils.getDefinitionByName;
    import flash.utils.getQualifiedClassName;

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
