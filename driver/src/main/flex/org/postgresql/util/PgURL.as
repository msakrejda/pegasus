package org.postgresql.util {

    public class PgURL {
        private var _url:String;
        private var _port:int;
        private var _host:String;
        private var _db:String;
        private var _args:Object;
        /**
         * Parse a simple URL syntax similar to that of the PostgreSQL JDBC driver
         * <code>asdbc:postgresql//localhost:5432/mydb?param1=val1&amp;param2=val2</code>.
         */
        public function PgURL(url:String) {
            // TODO: Throw InvalidArgumentException if url does not match expected syntax
            _url = url;
            // N.B.: this parsing method is pretty ghetto, especially the restrictions on characters
            // in hostname, db name, and parameter keys and values, as well as the inability to escape
            // anything. We should support anything allowed by DNS for host names, anything allowed
            // by PostgreSQL as a db name for db, and something reasonably flexible for param keys
            // and values.
            var urlParts:Array = url.split('?');
            var root:String = urlParts[0];
            var args:String = urlParts.length > 1 ? urlParts[1] : null;
            var rootElems:Array = new RegExp("asdbc:postgresql://([\\w\\.]+)(?::(\\d+))?/(\\w+)").exec(root);
            var argElems:Array = args ? args.split("&") : [];
            if (!rootElems) {
                throw new ArgumentError("Invalid url: " + url);
            }
            _host = rootElems[1];
            _port = int(rootElems[2]) || 5432;
            _db = rootElems[3];
            _args = {};

            for each (var argPair:String in argElems) {
                var pair:Array = new RegExp("(\\w+)=(\\w+)").exec(argPair);
                if (!pair || pair.length != 3) {
                    throw new ArgumentError("Invalid parameter in url: " + argPair);
                }
                _args[pair[1]] = pair[2];
            }
        }

        public function get host():String {
            return _host;
        }

        public function get port():int {
            return _port;
        }

        public function get db():String {
            return _db;
        }

        public function get parameters():Object {
            return _args;
        }

        public function toString():String {
            return _url;
        }

    }
}