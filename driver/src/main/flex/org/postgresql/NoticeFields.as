package org.postgresql {

    public class NoticeFields {

        private static const FIELD_DESCRIPTIONS:Object = {
            S : 'SEVERITY',
            C : 'CODE',
            M : 'MESSAGE',
            D : 'DETAIL',
            H : 'HINT',
            P : 'POSITION',
            p : 'INTERNAL POSITION',
            q : 'INTERNAL QUERY',
            W : 'WHERE',
            F : 'FILE',
            L : 'LINE',
            R : 'ROUTINE'
        };

        public static const SEVERITY:String = 'S';
        public static const CODE:String = 'C';
        public static const MESSAGE:String = 'M';
        public static const DETAIL:String = 'D';
        public static const HINT:String = 'H';
        public static const POSITION:String = 'P';
        public static const INTERNAL_POSITION:String = 'p';
        public static const INTERNAL_QUERY:String = 'q';
        public static const WHERE:String = 'W';
        public static const FILE:String = 'F';
        public static const LINE:String = 'L';
        public static const ROUTINE:String = 'R';

        public static function describe(fieldCode:String):String {
            if (fieldCode in FIELD_DESCRIPTIONS) {
                return FIELD_DESCRIPTIONS[fieldCode];
            } else {
                return "UNKNOWN FIELD (" + fieldCode + ")";
            }
        }

    }
}