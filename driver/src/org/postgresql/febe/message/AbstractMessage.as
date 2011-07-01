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

        /**
         * Print the message type.
         *
         * @see #type
         */
        public function toString():String {
            return type;
        }

        /**
         * Get character code of first character in given String.
         *
         * @param str String, must be a single character
         */
        protected function code(str:String):int {
            if (str.length > 1) {
                throw new ArgumentError("Expected single character, got " + str);
            } else {
                return str.charCodeAt(0);
            }
        }
    }

}