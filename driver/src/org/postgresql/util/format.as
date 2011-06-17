package org.postgresql.util {

    /**
     * Format the template by substituting any parameter marker with its
     * corresponding argument. Parameter markers are defined by a number
     * (indicating the argument index to replace) enclosed by curly braces.
     * <p/>
     * E.g., an invocation such as <code>format("{1} {0}!", 'world', 'hello')</code>
     * would return the string <code>hello world!</code>.
     * <p/>
     * If the replacement values are not Strings, they are coerced to
     * Strings before substitution, as per the <code>String</code> function.
     *
     * @param template String in which to perform parameter substitution
     * @param args arguments to substitute
     * @return a String with all token references subtituted with their corresponding values
     * @throws ArgumentException if more values are referenced than provided
     * @see String
     */
    public function format(template:String, ...args):String {
        return template.replace(/{(\d+)}/g, function():String {
            var replacementIndex:int = int(arguments[1]);
            if (replacementIndex > args.length) {
                throw new ArgumentError("Invalid log argument index: " + replacementIndex);
            } else {
                return String(args[replacementIndex]);
            }
        });
    }
}