package org.postgresql.util {

    public function format(template:String, ...args):String {
        return template.replace(/{(\d+)}/g, function():String {
            var replacementIndex:int = int(arguments[1]);
            return replacementIndex < args.length ?
                args[replacementIndex] :
                arguments[0];
        });
    }
}