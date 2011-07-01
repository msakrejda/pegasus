package org.postgresql.db.impl {
    import org.postgresql.db.IColumn;
    /**
     * Basic <code>IColumn</code> implementation.
     */
    internal class Column implements IColumn {
        private var _name:String;
        private var _type:Class;
        private var _typeOid:int;

        /**
         * @private
         */
        public function Column(name:String, type:Class, typeOid:int) {
            _name = name;
            _type = type;
            _typeOid = typeOid;
        }

        /**
         * Column name.
         */
        public function get name():String { return _name; }

        /**
         * Column client-side type (i.e., actual ActionScript <code>Class</code> this data has been decoded to).
         */
        public function get type():Class { return _type; }

        /**
         * Column server-side type (i.e., original oid of result column in PostgreSQL).
         */
        public function get typeOid():int { return _typeOid; }
    }
}