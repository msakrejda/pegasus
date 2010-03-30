package org.postgresql.db {
    import flash.events.EventDispatcher;
    
    public class Result extends EventDispatcher {
        public var affectedRows:int;
        public var insertOid:int;
    }
}