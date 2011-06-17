package org.postgresql.log {
    /**
     * An <code>ILogger</code> allows logging of messages from a given source
     * and passes them on to the logging framework (for routing and publishing
     * through <code>ILogTarget</code>s).
     */
    public interface ILogger {
        /**
         * The category this logger logs messages for.
         */
        function get category():String;
        /**
         * Log a message at the given level. Parameters should be substituted according to
         * positional markers.
         *
         * @param level <code>LogLevel</code> to use
         * @param message message to log
         * @param rest parameters to substitute, if any
         * @see org.postgresql.log.LogLevel
         */
        function log(level:int, message:String, ...rest):void;
        /**
         * Log a message at fine level.
         *
         * @see #log
         */
        function fine(message:String, ...rest):void;
        /**
         * Log a message at debug level.
         *
         * @see #log
         */
        function debug(message:String, ...rest):void;
        /**
         * Log a message at info level.
         *
         * @see #log
         */
        function info(message:String, ...rest):void;
        /**
         * Log a message at warning level.
         *
         * @see #log
         */
        function warn(message:String, ...rest):void;
        /**
         * Log a message at error level.
         *
         * @see #log
         */
        function error(message:String, ...rest):void;
        /**
         * Log a message at fatal level.
         *
         * @see #log
         */
        function fatal(message:String, ...rest):void;
    }
}