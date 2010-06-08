package org.postgresql.log {
	import flash.system.Capabilities;
	
	import org.postgresql.util.AbstractMethodError;
	import org.postgresql.util.DateFormatter;
	import org.postgresql.util.assert;

	public class AbstractLogTarget implements ILogTarget {
		
		private var _format:String;
/*
		 *	%d	date in YYYY-MM-DD format
		 *	%t	time in HH:MM:SS format
		 *	%l	log level
		 *	%c	class
		 *	%m	method
		 *	%n	line number
		 * 	%s	message
		 *
 */

		private var _timeFormatter:DateFormatter;
		private var _dateFormatter:DateFormatter;

 		private var _getStack:Boolean;

 		public function AbstractLogTarget() {
			format = '%d %t [%l]: %c - %m (%n): %s';
			// TODO: replace with non-Flex utility classes
 			_dateFormatter = new DateFormatter();
 			_dateFormatter.formatString = 'YYYY-MM-DD';

 			_timeFormatter = new DateFormatter();
 			_timeFormatter.formatString = 'JJ:NN:SS';
 		}

		public function get format():String {
			return _format;
		}
		public function set format(value:String):void {
			if (_format != value) {
				_format = value;
				if (/%[mn]/.test(value)) {
					_getStack = true;
				} else {
					_getStack = false;
				}
			}
		}
		
		public function handleMessage(level:int, category:String, msg:String):void {
			var methodName:String = '<unknown>';
			var lineNo:String = '??';
			if (Capabilities.isDebugger && (_getStack)) {
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
						// For now, we ignore the captured class and just use the category, although
						// that may change in the future (e.g., regarding non-Class-related functions)
						//
						// Note that 'global/' is a prefix for non-method functions (e.g., assert). In these
						// cases, the package name still follows.
						var match:Array = String(stackElements[methodIndex]).match(new RegExp(
							'\\s+at ((?:global/)?' + symbolName + '(?:\\.' + symbolName + ')*::)?(?:(' + symbolName +
							')/)?(' + symbolName + '|<anonymous>)\\(\\)\\[.*:(\\d+)\\]'
						));
						if (match) {
							var packageStr:String = (match[1] || '');
							var classStr:String
							if (packageStr) {
								classStr = packageStr + '.';
							} else {
								classStr = '';
							}
							classStr += (match[2] || '<none>');

							methodName = match[3];
							assert("Could not find method name in stack trace", methodName);

							lineNo = match[4];
							assert("Could not find line number in stack trace", lineNo);
						}
						
					}
					
				}
			}
			var logTime:Date = new Date();
			var result:String = _format.replace(/%[dtlcmns]/g, function():String {
				var token:String = arguments[0];
				switch (token) {
					case '%d':	return _dateFormatter.format(logTime);
					case '%t':	return _timeFormatter.format(logTime);
					case '%l':	return LogLevel.toString(level);
					case '%c':	return category;
					case '%m':	return methodName;
					case '%n':	return lineNo;
					case '%s':	return msg;
					default  :	throw new ArgumentError("Unexpected match: " + token);
				}
			});
			doHandleMessage(result);
		}
		
		protected function doHandleMessage(msg:String):void {
			throw new AbstractMethodError();
		}
		
	}
}