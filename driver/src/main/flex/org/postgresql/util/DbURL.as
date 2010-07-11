package org.postgresql.util {

    public class DbURL {
        private var _url:String;
        private var _port:int;
        private var _host:String;
        private var _db:String;
        private var _args:Object;
        /**
         * Parse a simple jdbc-like db URL syntax:
         * <code>as3dbc://localhost:5432/mydb?param1=val1&param2val2</code>.
         */ 
        public function DbURL(url:String) {
            _url = url;
            var urlParts:Array = url.split('?');
            var root:String = urlParts[0];
            var args:String = urlParts.length > 1 ? urlParts[1] : null;
            var rootElems:Array = new RegExp("as3dbc:postgresql://(\\w+)(?::(\\d+))?/(\\w+)").exec(root);
            var argElems:Array = args ? args.split("&") : [];
            if (!rootElems) {
                throw new ArgumentError("Invalid url: " + url);
            }
            _host = rootElems[1];
            _port = rootElems[2] as int || 5432;
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