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

        /**
         * Name of parameter that has changed.
         */
        public var name:String;

        /**
         * New value for the parameter. Note that this is a string representation
         * of the value, even for numeric parameters.
         */
        public var value:String

        public function ParameterChangeEvent(name:String, newValue:String) {
            super(PARAMETER_CHANGE);
            this.name = name;
            this.value = newValue;
        }
        
    }
}