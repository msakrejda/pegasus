package org.postgresql.log {

    /**
     * Class defining constants for various logging level values
     */
    public class LogLevel {

        /**
         * Detailed debugging output
         */
        public static const FINE:int = 0;
        /**
         * Normal debugging output
         */
        public static const DEBUG:int = 1;
        /**
         * Standard informational messages
         */
        public static const INFO:int = 2;
        /**
         * Warnings
         */
        public static const WARN:int = 3;
        /**
         * Non-fatal errors
         */
        public static const ERROR:int = 4;
        /**
         * Fatal errors
         */
        public static const FATAL:int = 5;
        /**
         * Level used to indicate that no logging output should be produced.
         */
        public static const NONE:int = int.MAX_VALUE;

        /**
         * String representation of given <code>LogLevel</code>
         *
         * @param LogLevel to describe
         * @return String description of given level
         */
        public static function toString(level:int):String {
            switch (level) {
                case FINE:      return 'FINE';
                case DEBUG:     return 'DEBUG';
                case INFO:      return 'INFO';
                case WARN:      return 'WARN';
                case ERROR:     return 'ERROR';
                case FATAL:     return 'FATAL';
                default:        return 'UNKNOWN';
            }
        }
    }
}