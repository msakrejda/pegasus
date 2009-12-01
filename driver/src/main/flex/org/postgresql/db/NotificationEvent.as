package org.postgresql.db {

    import flash.events.Event;

    public class NotificationEvent extends Event {

        public function NotificationEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
            super(type, bubbles, cancelable);
        }

    }
}