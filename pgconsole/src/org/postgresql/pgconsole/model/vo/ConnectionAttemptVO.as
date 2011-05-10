package org.postgresql.pgconsole.model.vo {

    public class ConnectionAttemptVO {

        private var _url:String;
        private var _username:String;
        private var _password:String;

        public function ConnectionAttemptVO(url:String, username:String, password:String):void {
            _url = url;
            _username = username;
            _password = password;
        }

        public function get url():String {
            return _url;
        }

        public function get username():String {
            return _username;
        }

        public function get password():String {
            return _password;
        }


    }
}
