package org.postgresql {

    /**
     * OIDs for all the main PostgreSQL data types.
     */
    public class Oid {
        public static const UNSPECIFIED:int = 0;
        public static const INT2:int = 21;
        public static const INT4:int = 23;
        public static const INT8:int = 20;
        public static const TEXT:int = 25;
        public static const NUMERIC:int = 1700;
        public static const FLOAT4:int = 700;
        public static const FLOAT8:int = 701;
        public static const BOOL:int = 16;
        public static const DATE:int = 1082;
        public static const TIME:int = 1083;
        public static const TIMETZ:int = 1266;
        public static const TIMESTAMP:int = 1114;
        public static const TIMESTAMPTZ:int = 1184;
        public static const BYTEA:int = 17;
        public static const VARCHAR:int = 1043;
        public static const OID:int = 26;
        public static const BPCHAR:int = 1042;
        public static const MONEY:int = 790;
        public static const NAME:int = 19;
        public static const BIT:int = 1560;
        public static const VOID:int = 2278;
        public static const INTERVAL:int = 1186;
        public static const CHAR:int = 18; // (single char)
        public static const VARBIT:int = 1562;
        public static const UNKNOWN:int = 705;
    }
}