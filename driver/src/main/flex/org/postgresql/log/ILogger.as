package org.postgresql.log
{
    public interface ILogger
    {
        function get category():String;
        function log(level:int, message:String, ...rest):void;
        function fine(message:String, ...rest):void;
        function debug(message:String, ...rest):void;
        function info(message:String, ...rest):void;
        function warn(message:String, ...rest):void;
        function error(message:String, ...rest):void;
        function fatal(message:String, ...rest):void;
    }
}