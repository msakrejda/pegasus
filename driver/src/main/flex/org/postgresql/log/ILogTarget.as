package org.postgresql.log  {
    /**
     * An <code>ILogTarget</code> receives log messages from the logging framework and
     * publishes them for consumption by an end user. This can be achieved through <code>trace</code>
     * statement, browser integration through <code>ExternalInterface</code>, shipping
     * to the back-end, or any other such means. The <code>ILogTarget</code> should format
     * the incoming messages according to the configured format string.
     */
    public interface ILogTarget {
        /**
         * Format string:
         * <pre>
         *    %d    date in YYYY-MM-DD format
         *    %t    time in HH:MM:SS format
         *    %l    log level
         *    %c    category
         *    %m    method
         *    %n    line number
         *    %s    message
         * </pre>
         * All other characters are printed literally. These format specifications cannot
         * be escaped; the corresponding characters always convey formatting information.
         *
         * @param value format to use
         */
        function set format(value:String):void;
        /**
         * Handle the given message according to the currently configured format. Note that
         * if method and line number are used in the format String, it is the <code>ILogTarget</code>'s
         * responsibility to determine this information.
         */
        function handleMessage(level:int, category:String, msg:String):void;
    }
}