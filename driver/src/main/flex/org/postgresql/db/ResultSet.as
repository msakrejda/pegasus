package org.postgresql.db {

    import flash.events.EventDispatcher;

    // TODO: with result streaming, the results property can't just
    // provide the full results. It can provide the latest, or just null
    // to indicate that 
    public class ResultSet extends EventDispatcher implements IResultSet {

        private var _columns:Array;

        public var streaming:Boolean = false;
        
        internal function setColumns(value:Array):void {
            _columns = value;
        }

        internal function handleData(data:*):void {
            //
        }

        public function get columns():Array {
            return [];
        }

        public function get data():* {
            return [];
        }

        public function close():void {
            
        }

    }
}