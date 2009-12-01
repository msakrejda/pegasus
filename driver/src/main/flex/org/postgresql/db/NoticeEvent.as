package org.postgresql.db {

    import flash.events.Event;

    public class NoticeEvent extends Event {

        public static const NOTICE:String = 'NoticeEventNotice';
        public static const ERROR:String = 'NoticeEventError';

        public var fields:Object;

        public function NoticeEvent(type:String, fields:Object, bubbles:Boolean=false, cancelable:Boolean=false) {
            super(type, bubbles, cancelable);
            this.fields = fields;
        }

    }
}