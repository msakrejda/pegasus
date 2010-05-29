package org.postgresql.log {

	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;

	public class Log {

		private static var _categoryLoggers:Object = {};
		private static var _categoryTargets:Object = {};

		private static var _targetLevels:Dictionary = new Dictionary();
		private static var _classToCategory:Dictionary = new Dictionary();

		public static function getLogger(clazz:Class):ILogger {
			// TODO: this does not work well for top-level functions like assert, since
			// getQualifiedClassName returns 'builtin.as$0::MethodClosure'
			var type:String = flash.utils.getQualifiedClassName(clazz).replace('::', '.');
			_classToCategory[clazz] = type;
			if (!(type in _categoryLoggers)) {
				_categoryLoggers[type] = new Logger(type, doLog);
				_categoryTargets[type] = [];
			}
			return _categoryLoggers[type];
		}
		public static function addTarget(target:ILogTarget, level:int, filters:Array=null):void {
			for (var category:String in _categoryTargets) {
				if (!filters) {
					// this is a catch-all target
					_categoryTargets[category].push(target);
				} else {
					for each (var filter:String in filters) {
						var expr:String = filter.replace('.', '\\.').replace('*', '.*');
						if (new RegExp('^' + expr).test(category)) {
							_categoryTargets[category].push(target);
							break;
						}
					}
				}
			}
			_targetLevels[target] = level;
		}
		public static function removeTarget(target:ILogTarget):void {
			delete _targetLevels[target];
			for (var category:String in _categoryTargets) {
				var targets:Array = _categoryTargets[category];
				for (var i:int = 0; i < targets.length; i++) {
					if (targets[i] == target) {
						targets.splice(i, 1);
						i--;
					}
				}
			}
		}
		private static function doLog(level:int, category:String, message:String):void {
			var targets:Array = _categoryTargets[category];
			for each (var target:ILogTarget in targets) {
				var targetThreshold:int = _targetLevels[target];
				if (level >= targetThreshold) {
					target.handleMessage(level, category, message);
				}
			}
		}
	}
}
	import org.postgresql.log.ILogger;
	import org.postgresql.log.LogLevel;
	
	
class Logger implements ILogger {

	private var _cat:String;
	private var _logMsg:Function;

	public function Logger(cat:String, logMsg:Function) {
		_cat = cat;
		_logMsg = logMsg;
	}
	public function get category():String { return _cat; }
	public function log(level:int, message:String, ...rest):void {
		doLog(level, message, rest);
	}
	private function doLog(level:int, message:String, rest:Array):void {
		var result:String = message.replace(/{(\d+)}/, function():String {
			var idx:int = int(arguments[1]);
			if (idx > rest.length || idx < 0) {
				throw new ArgumentError("Invalid log argument index: " + idx);
			} else {
				return rest[idx];
			}
		});
		_logMsg(level, _cat, result);
	}
	public function fine(message:String, ...rest):void { doLog(LogLevel.FINE, message, rest); }
	public function debug(message:String, ...rest):void { doLog(LogLevel.DEBUG, message, rest); }
	public function info(message:String, ...rest):void { doLog(LogLevel.INFO, message, rest); }
	public function warn(message:String, ...rest):void { doLog(LogLevel.WARN, message, rest); }
	public function error(message:String, ...rest):void { doLog(LogLevel.ERROR, message, rest); }
	public function fatal(message:String, ...rest):void { doLog(LogLevel.FATAL, message, rest); }
}