package org.postgresql.febe.message {

    public class AbstractMessage implements IMessage {

        /**
         * This returns the unqualified class name; we
         * name our messages using FEBE message names,
         * so this corresponds to the official messages names
         */
        public function get type():String {
            var classStr:String = String(Object(this).constructor);
            return classStr.replace(/\[class (\w+)\]/, '$1');
        }

        public function toString():String {
            return type;
        }

        protected function code(str:String):int {
            if (str.length > 1) {
                throw new Error("Expected single character, got " + str);
            } else {
                return str.charCodeAt(0);
            }
        }
    }

}