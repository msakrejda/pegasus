package org.postgresql.event {

    import flash.events.Event;

    public class ParameterChangeEvent extends Event {

        public static const PARAMETER_CHANGE:String = 'parameterChange';

        public var name:String;
        public var value:Object;
        public function ParameterChangeEvent(name:String, newValue:Object) {
            super(PARAMETER_CHANGE);
            this.name = name;
            this.value = newValue;
        }
        
    }
}