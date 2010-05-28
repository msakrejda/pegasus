package org.postgresql.log {

	public class LogLevel {

		public static const FINE:int = 0;
		public static const DEBUG:int = 1;
		public static const INFO:int = 2;
		public static const WARN:int = 3;
		public static const ERROR:int = 4;
		public static const FATAL:int = 5;
		public static const NONE:int = int.MAX_VALUE;

		public static function toString(level:int):String {
			switch (level) {
				case FINE:		return 'FINE';
				case DEBUG: 	return 'DEBUG';
				case INFO:		return 'INFO';
				case WARN:		return 'WARN';
				case ERROR:		return 'ERROR';
				case FATAL:		return 'FATAL';
				default:		return 'UNKNOWN';
			}
		}
	}
}