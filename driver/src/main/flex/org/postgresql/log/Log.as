package org.postgresql.log {

    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;

    /**
     * The central class in the logging framework. <code>ILogTarget</code>s are configured
     * here and <code>ILogger</code>s are looked up here.
     */
    public class Log {

        private static var _categoryLoggers:Object = {};
        private static var _categoryTargets:Object = {};

        private static var _targetLevels:Dictionary = new Dictionary();
        private static var _targetFilters:Dictionary = new Dictionary();
        private static var _classToCategory:Dictionary = new Dictionary(true);

        /**
         * Obtain an <code>ILogger</code> for the given Class.
         *
         * @param clazz Class for which to obtain ILogger
         * @return ILogger for this Class
         */
        public static function getLogger(clazz:Class):ILogger {
            // TODO: this does not work well for top-level functions like assert, since
            // getQualifiedClassName returns 'builtin.as$0::MethodClosure'
            var type:String;
            if (clazz in _classToCategory) {
                type = _classToCategory[clazz];
            } else {
                type = flash.utils.getQualifiedClassName(clazz).replace('::', '.');
            }

            _classToCategory[clazz] = type;
            if (!(type in _categoryLoggers)) {
                _categoryLoggers[type] = new Logger(type, doLog);
                _categoryTargets[type] = new Dictionary();
                // rescan all targets to see if they match this category
                for (var target:* in _targetLevels) {
                    addTarget(target, _targetLevels[target], _targetFilters[target]);
                }
            }
            return _categoryLoggers[type];
        }

        /**
         * Add a logging target. Check existing categories to see if they should log to this target.
         * Check future categories as well. Filters passed in, if any, should be an Array of Strings
         * indicating specific Classes or wildcards at the package level (e.g., <code>'org.postgresql.*'</code>).
         * If target is already configured, replace it.
         *
         * @param target ILogTarget to add
         * @param level level at which to add target
         * @param filters filters to use for target
         * @see org.postgresql.log.LogLevel
         */
        public static function addTarget(target:ILogTarget, level:int, filters:Array=null):void {
            for (var category:String in _categoryTargets) {
                if (!filters) {
                    // this is a catch-all target
                    _categoryTargets[category][target] = true;
                } else {
                    for each (var filter:String in filters) {
                        var expr:String = filter.replace('.', '\\.').replace('*', '.*');
                        if (new RegExp('^' + expr).test(category)) {
                            _categoryTargets[category][target] = true;
                            break;
                        }
                    }
                }
            }
            _targetLevels[target] = level;
            _targetFilters[target] = filters;
        }

        /**
         * Remove logging target. If target is not configured, do nothing.
         *
         * @param target target to remove
         */
        public static function removeTarget(target:ILogTarget):void {
            delete _targetLevels[target];
            delete _targetFilters[target];

            for (var category:String in _categoryTargets) {
                var targets:Dictionary = _categoryTargets[category];
                delete targets[target];
            }
        }
        private static function doLog(level:int, category:String, message:String):void {
            var targets:Dictionary = _categoryTargets[category];
            for (var target:* in targets) {
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
        var result:String = message.replace(/{(\d+)}/g, function():String {
            var idx:int = int(arguments[1]);
            if (idx > rest.length || idx < 0) {
                throw new ArgumentError("Invalid log argument index: " + idx);
            } else {
                return rest[idx];
            }
        });
        //trace(_cat, 'logging', result);
        _logMsg(level, _cat, result);
    }
    public function fine(message:String, ...rest):void { doLog(LogLevel.FINE, message, rest); }
    public function debug(message:String, ...rest):void { doLog(LogLevel.DEBUG, message, rest); }
    public function info(message:String, ...rest):void { doLog(LogLevel.INFO, message, rest); }
    public function warn(message:String, ...rest):void { doLog(LogLevel.WARN, message, rest); }
    public function error(message:String, ...rest):void { doLog(LogLevel.ERROR, message, rest); }
    public function fatal(message:String, ...rest):void { doLog(LogLevel.FATAL, message, rest); }
}