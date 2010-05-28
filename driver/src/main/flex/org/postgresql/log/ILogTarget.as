package org.postgresql.log
{
	public interface ILogTarget
	{
		function handleMessage(level:int, category:String, msg:String):void;
	}
}