package org.postgresql.pegasus {
    import flash.utils.ByteArray;
    /**
     * Credentials using for testing. 
     */
    public class Credentials {

        [Embed(source="../test-config.xml", mimeType="application/octet-stream")]
        private static const ConfigXML:Class;
        private static var _config:XML;

        private static function get config():XML {
            // TODO: this should be possible in a static initializer block, but I'm getting
            // odd errors about undefined properties when I try to do that
            if (!_config) {
                var ba:ByteArray = (new ConfigXML()) as ByteArray;
                var str:String = ba.readUTFBytes(ba.length);
                _config = new XML(str);
               }
            return _config;
        }

        public static function get user():String { return config.user; }
        public static function get password():String { return config.password; }
        public static function get url():String { return config.url; }
    }
}
