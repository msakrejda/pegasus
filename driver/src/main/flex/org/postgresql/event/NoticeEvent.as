package org.postgresql.event {

    import flash.events.Event;

    public class NoticeEvent extends Event {

        public static const NOTICE:String = 'noticeNoticeEvent';
        public static const ERROR:String = 'errorNoticeEvent';

        public var fields:Object;

        public function NoticeEvent(type:String, fields:Object) {
            super(type);
            this.fields = fields;
        }

    }
}