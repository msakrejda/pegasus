package org.postgresql.event {

    import flash.events.Event;

    public class ResultEvent extends Event {

        public static const RESULT:String = 'result'; 

        public var command:String;
        public var affectedRows:int;
        public var insertOid:int;

        public function ResultEvent(type:String, command:String, affected:int, oid:int) {
            super(type);
            this.command = command;
            this.insertOid = oid;
            this.affectedRows = affected;
        }
    }
}