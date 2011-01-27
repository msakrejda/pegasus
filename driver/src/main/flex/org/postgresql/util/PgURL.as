package org.postgresql.util {
    /**
     * Parses a simple URL syntax similar to that of the PostgreSQL JDBC driver. E.g.,
     * <code>asdbc:postgresql//localhost:5432/mydb?param1=val1&amp;param2=val2</code>.
     * More formally, the URL has several parts:
     * <ul>
     *  <li><code><b>asdbc</b>:<b>postgresql</b>//</code> protocol and subprotocol designation</li>
     *  <li><code><b>localhost</b></code> host (running the PostgreSQL server) to connect to</li>
     *  <li><code>:<b>5432</b></code> port on which PostgreSQL is running</li>
     *  <li><code>/<b>mydb</b></code> database to connect to</li>
     *  <li><code>?<b>param1</b>=<b>val1</b></code> first key/value pair specifying connection parameter</li>
     *  <li><code>&amp;<b>param2</b>=<b>val2</b></code> additional connection parameters</li>
     * </ul>
     * The delimiter characters cannot occur in the URL elements. The port and parameters
     * are all optional. The additional parameters may occur zero or more times.
     */
    public class PgURL {
        private var _url:String;
        private var _port:int;
        private var _host:String;
        private var _db:String;
        private var _args:Object;
        /**
         * Construct a new PgURL
         * @param url the URL to parse
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

        /**
         * Host (running PostgreSQL server) to connect to.
         */
        public function get host():String {
            return _host;
        }

        /**
         * Port on which server is running.
         */
        public function get port():int {
            return _port;
        }

        /**
         * Database to connect to (note that in PostgreSQL, a connection is tied to a single database).
         */
        public function get db():String {
            return _db;
        }

        /**
         * Map of connection parameter keys to their corresponding values. Note that the values
         * are represented as Strings.
         */
        public function get parameters():Object {
            return _args;
        }

        /**
         * A human-readable representation of this URL, corresponding to the URL originally parsed.
         */
        public function toString():String {
            return _url;
        }

    }
}