package org.postgresql.log {
	import flash.system.Capabilities;
	
	import org.postgresql.util.AbstractMethodError;
	import org.postgresql.util.assert;

	public class AbstractLogTarget implements ILogTarget {

		public var includeCategory:Boolean;
		public var includeClass:Boolean;
		public var includeMethod:Boolean;
		public var includeLine:Boolean;
		public var includeDate:Boolean;
		public var includeTime:Boolean;

		public var fieldSeparator:String;

		public function AbstractLogTarget() {
			includeCategory = true;
			// Class is usually going to be the same thing as category
			includeClass = false; 
			includeMethod = false;
			includeLine = false;
			includeDate = true;
			includeTime = true;

			fieldSeparator = ' ';
		}
		
		public function handleMessage(level:int, category:String, msg:String):void {
			// TODO: respect includeCategory
			var result:String = '[' + LogLevel.toString(level) + ']' + fieldSeparator + category;
			if (Capabilities.isDebugger && (includeClass || includeMethod || includeLine)) {
				var stack:String = new Error().getStackTrace();
				if (stack) {
					// We're in business--massive hackery ensues
					var stackElements:Array = stack.split('\n');
					// We dig back up the stack for the method that called the logger.
					// We know the first line is not it, since that's the error message,
					// and the second line is also not it, since that's this method. We
					// can also skip the third line, as loggers don't call targets directly.
					// We start looking at index 4. Note that this whole nonsense is insanely
					// tightly coupled to the Log class itself.
					var methodIndex:int = 4;
					var found:Boolean = false;
					while (methodIndex < stackElements.length) {
						// Note that the Logger inner class appears not to have a package
						if (/\s+at Logger\/(log|fine|debug|info|warn|error|fatal)/.test(stackElements[methodIndex++])) {
							found = true;
							break;
						}
					}
					if (found) {
						var symbolName:String = '[a-zA-Z_$][a-zA-Z_$0-9]*';
						// The subgroup matches will be:
						// 1. package (if any)
						// 2. class (if any)
						// 3. function (or <anonymous>)
						// 4. line no
						var match:Array = String(stackElements[methodIndex]).match(new RegExp(
							'\\s+at ((?:global/)' + symbolName + '(?:\\.' + symbolName + ')*::)?(?:(' + symbolName +
							')/)?(' + symbolName + '|<anonymous>)\\(\\)\\[.*:(\\d+)\\]'
						));
						if (match) {
							var extraFields:Array = [];
							if (includeClass) {
								var packageStr:String = (match[1] || '');
								var classStr:String
								if (packageStr) {
									classStr = packageStr + '.';
								} else {
									classStr = '';
								}
								classStr += (match[2] || '<none>');

								extraFields.push(classStr); 
							}
							if (includeMethod) {
								var methodName:String = match[3];
								assert("Could not find method name in stack trace", methodName);
								extraFields.push(methodName);
							}
							if (includeLine) {
								var lineNo:String = match[4];
								assert("Could not find line number in stack trace", lineNo);
								extraFields.push(lineNo);
							}
							if (extraFields.length > 0) {
								result += fieldSeparator + extraFields.join(fieldSeparator);
							}
						}
						
					}
					
				}
			} 
			doHandleMessage(result + fieldSeparator + msg);
		}
		
		protected function doHandleMessage(msg:String):void {
			throw new AbstractMethodError();
		}
		
	}
}