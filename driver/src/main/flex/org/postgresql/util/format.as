package org.postgresql.util {

    /**
     * Format the template by substituting any parameter marker with its
     * corresponding argument. Parameter markers are defined by a number
     * (indicating the argument index to replace) enclosed by curly braces.
     * E.g., an invocation such as <code>format("{1} {0}!", 'world', 'hello')</code>
     * would return the string <code>hello world!</code>.
     * @param template String in which to perform parameter substitution
     * @param args arguments to substitute
     */
    public function format(template:String, ...args):String {
        return template.replace(/{(\d+)}/g, function():String {
            var replacementIndex:int = int(arguments[1]);
            return replacementIndex < args.length ?
                args[replacementIndex] :
                arguments[0];
        });
    }
}