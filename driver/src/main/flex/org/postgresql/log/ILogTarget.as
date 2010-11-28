package org.postgresql.log
{
    public interface ILogTarget
    {
        /**
         * Format string:
         *
         *    %d    date in YYYY-MM-DD format
         *    %t    time in HH:MM:SS format
         *    %l    log level
         *    %c    category
         *    %m    method
         *    %n    line number
         *    %s    message
         *
         * All other characters are printed literally. These format
         * specifications cannot be escaped.
         */
        function set format(value:String):void;
        function handleMessage(level:int, category:String, msg:String):void;
    }
}