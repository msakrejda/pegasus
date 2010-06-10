package org.postgresql.util {

	public function format(template:String, ...arguments):String {
		return template.replace(/{(\d+)}/, function():String {
			var replacementIndex:int = int(arguments[1]);
			return replacementIndex < arguments.length ?
				arguments[replacementIndex] :
				arguments[0];
		});
	}
}