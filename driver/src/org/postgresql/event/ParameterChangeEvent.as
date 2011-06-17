package org.postgresql.event {

    import flash.events.Event;

    /**
     * Indicates a change in a server configuration paramter.
     */
    public class ParameterChangeEvent extends Event {

        /**
         * A parameter change.
         */
        public static const PARAMETER_CHANGE:String = 'parameterChange';

        private var _name:String;
        private var _value:String;

        /**
         * Name of parameter that has changed.
         */
        public function get name():String {
            return _name;
        }

        /**
         * New value for the parameter. Note that this is a string representation
         * of the value, even for numeric parameters.
         */
        public function get value():String {
            return _value;
        }

        /**
         * Create a new event
         *
         * @param name name of parameter which changed
         * @param name newValue new value of parameter
         *
         * @private
         */
        public function ParameterChangeEvent(name:String, newValue:String) {
            super(PARAMETER_CHANGE);
            _name = name;
            _value = newValue;
        }

    }
}