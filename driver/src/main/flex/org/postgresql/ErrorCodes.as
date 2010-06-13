package org.postgresql {
    // error codes from: http://www.postgresql.org/docs/8.4/static/errcodes-appendix.html
    public class ErrorCodes {
        public static const errors:Object = {
            // Class 00 — Successful Completion
            '00000' : "SUCCESSFUL COMPLETION",
            // Class 01 — Warning
            '01000' : "WARNING",
            '0100C' : "DYNAMIC RESULT SETS RETURNED",
            '01008' : "IMPLICIT ZERO BIT PADDING",
            '01003' : "NULL VALUE ELIMINATED IN SET FUNCTION",
            '01007' : "PRIVILEGE NOT GRANTED",
            '01006' : "PRIVILEGE NOT REVOKED",
            '01004' : "STRING DATA RIGHT TRUNCATION",
            '01P01' : "DEPRECATED FEATURE",
            // Class 02 — No Data (this is also a warning class per the SQL standard)
            '02000' : "NO DATA",
            '02001' : "NO ADDITIONAL DYNAMIC RESULT SETS RETURNED",
            // Class 03 — SQL Statement Not Yet Complete
            '03000' : "SQL STATEMENT NOT YET COMPLETE",
            // Class 08 — Connection Exception
            '08000' : "CONNECTION EXCEPTION",
            '08003' : "CONNECTION DOES NOT EXIST",
            '08006' : "CONNECTION FAILURE",
            '08001' : "SQLCLIENT UNABLE TO ESTABLISH SQLCONNECTION",
            '08004' : "SQLSERVER REJECTED ESTABLISHMENT OF SQLCONNECTION",
            '08007' : "TRANSACTION RESOLUTION UNKNOWN",
            '08P01' : "PROTOCOL VIOLATION",
            // Class 09 — Triggered Action Exception
            '09000' : "TRIGGERED ACTION EXCEPTION",
            // Class 0A — Feature Not Supported
            '0A000' : "FEATURE NOT SUPPORTED",
            // Class 0B — Invalid Transaction Initiation
            '0B000' : "INVALID TRANSACTION INITIATION",
            // Class 0F — Locator Exception
            '0F000' : "LOCATOR EXCEPTION",
            '0F001' : "INVALID LOCATOR SPECIFICATION",
            // Class 0L — Invalid Grantor
            '0L000' : "INVALID GRANTOR",
            '0LP01' : "INVALID GRANT OPERATION",
            // Class 0P — Invalid Role Specification
            '0P000' : "INVALID ROLE SPECIFICATION",
            // Class 20 — Case Not Found
            '20000' : "CASE NOT FOUND",
            // Class 21 — Cardinality Violation
            '21000' : "CARDINALITY VIOLATION",
            // Class 22 — Data Exception
            '22000' : "DATA EXCEPTION",
            '2202E' : "ARRAY SUBSCRIPT ERROR",
            '22021' : "CHARACTER NOT IN REPERTOIRE",
            '22008' : "DATETIME FIELD OVERFLOW",
            '22012' : "DIVISION BY ZERO",
            '22005' : "ERROR IN ASSIGNMENT",
            '2200B' : "ESCAPE CHARACTER CONFLICT",
            '22022' : "INDICATOR OVERFLOW",
            '22015' : "INTERVAL FIELD OVERFLOW",
            '2201E' : "INVALID ARGUMENT FOR LOGARITHM",
            '22014' : "INVALID ARGUMENT FOR NTILE FUNCTION",
            '22016' : "INVALID ARGUMENT FOR NTH",
            '2201F' : "INVALID ARGUMENT FOR POWER FUNCTION",
            '2201G' : "INVALID ARGUMENT FOR WIDTH BUCKET FUNCTION",
            '22018' : "INVALID CHARACTER VALUE FOR CAST",
            '22007' : "INVALID DATETIME FORMAT",
            '22019' : "INVALID ESCAPE CHARACTER",
            '2200D' : "INVALID ESCAPE OCTET",
            '22025' : "INVALID ESCAPE SEQUENCE",
            '22P06' : "NONSTANDARD USE OF ESCAPE CHARACTER",
            '22010' : "INVALID INDICATOR PARAMETER VALUE",
            '22023' : "INVALID PARAMETER VALUE",
            '2201B' : "INVALID REGULAR EXPRESSION",
            '2201W' : "INVALID ROW COUNT IN LIMIT CLAUSE",
            '2201X' : "INVALID ROW COUNT IN RESULT OFFSET CLAUSE",
            '22009' : "INVALID TIME ZONE DISPLACEMENT VALUE",
            '2200C' : "INVALID USE OF ESCAPE CHARACTER",
            '2200G' : "MOST SPECIFIC TYPE MISMATCH",
            '22004' : "NULL VALUE NOT ALLOWED",
            '22002' : "NULL VALUE NO INDICATOR PARAMETER",
            '22003' : "NUMERIC VALUE OUT OF RANGE",
            '22026' : "STRING DATA LENGTH MISMATCH",
            '22001' : "STRING DATA RIGHT TRUNCATION",
            '22011' : "SUBSTRING ERROR",
            '22027' : "TRIM ERROR",
            '22024' : "UNTERMINATED C STRING",
            '2200F' : "ZERO LENGTH CHARACTER STRING",
            '22P01' : "FLOATING POINT EXCEPTION",
            '22P02' : "INVALID TEXT REPRESENTATION",
            '22P03' : "INVALID BINARY REPRESENTATION",
            '22P04' : "BAD COPY FILE FORMAT",
            '22P05' : "UNTRANSLATABLE CHARACTER",
            '2200L' : "NOT AN XML DOCUMENT",
            '2200M' : "INVALID XML DOCUMENT",
            '2200N' : "INVALID XML CONTENT",
            '2200S' : "INVALID XML COMMENT",
            '2200T' : "INVALID XML PROCESSING INSTRUCTION",
            // Class 23 — Integrity Constraint Violation
            '23000' : "INTEGRITY CONSTRAINT VIOLATION",
            '23001' : "RESTRICT VIOLATION",
            '23502' : "NOT NULL VIOLATION",
            '23503' : "FOREIGN KEY VIOLATION",
            '23505' : "UNIQUE VIOLATION",
            '23514' : "CHECK VIOLATION",
            // Class 24 — Invalid Cursor State
            '24000' : "INVALID CURSOR STATE",
            // Class 25 — Invalid Transaction State
            '25000' : "INVALID TRANSACTION STATE",
            '25001' : "ACTIVE SQL TRANSACTION",
            '25002' : "BRANCH TRANSACTION ALREADY ACTIVE",
            '25008' : "HELD CURSOR REQUIRES SAME ISOLATION LEVEL",
            '25003' : "INAPPROPRIATE ACCESS MODE FOR BRANCH TRANSACTION",
            '25004' : "INAPPROPRIATE ISOLATION LEVEL FOR BRANCH TRANSACTION",
            '25005' : "NO ACTIVE SQL TRANSACTION FOR BRANCH TRANSACTION",
            '25006' : "READ ONLY SQL TRANSACTION",
            '25007' : "SCHEMA AND DATA STATEMENT MIXING NOT SUPPORTED",
            '25P01' : "NO ACTIVE SQL TRANSACTION",
            '25P02' : "IN FAILED SQL TRANSACTION",
            // Class 26 — Invalid : "SQL S",
            '26000' : "INVALID SQL STATEMENT NAME",
            // Class 27 — Triggered Data Change Violation
            '27000' : "TRIGGERED DATA CHANGE VIOLATION",
            // Class 28 — Invalid Authorization Specification
            '28000' : "INVALID AUTHORIZATION SPECIFICATION",
            // Class 2B — Dependent Privilege Descriptors Still Exist
            '2B000' : "DEPENDENT PRIVILEGE DESCRIPTORS STILL EXIST",
            '2BP01' : "DEPENDENT OBJECTS STILL EXIST",
            // Class 2D — Invalid Transaction Termination
            '2D000' : "INVALID TRANSACTION TERMINATION",
            // Class 2F — SQL Routine Exception
            '2F000' : "SQL ROUTINE EXCEPTION",
            '2F005' : "FUNCTION EXECUTED NO RETURN STATEMENT",
            '2F002' : "MODIFYING SQL DATA NOT PERMITTED",
            '2F003' : "PROHIBITED SQL STATEMENT ATTEMPTED",
            '2F004' : "READING SQL DATA NOT PERMITTED",
            // Class 34 — Invalid Cursor Name
            '34000' : "INVALID CURSOR NAME",
            // Class 38 — External Routine Exception
            '38000' : "EXTERNAL ROUTINE EXCEPTION",
            '38001' : "CONTAINING SQL NOT PERMITTED",
            '38002' : "MODIFYING SQL DATA NOT PERMITTED",
            '38003' : "PROHIBITED SQL STATEMENT ATTEMPTED",
            '38004' : "READING SQL DATA NOT PERMITTED",
            // Class 39 — External Routine Invocation Exception
            '39000' : "EXTERNAL ROUTINE INVOCATION EXCEPTION",
            '39001' : "INVALID SQLSTATE RETURNED",
            '39004' : "NULL VALUE NOT ALLOWED",
            '39P01' : "TRIGGER PROTOCOL VIOLATED",
            '39P02' : "SRF PROTOCOL VIOLATED",
            // Class 3B — Savepoint Exception
            '3B000' : "SAVEPOINT EXCEPTION",
            '3B001' : "INVALID SAVEPOINT SPECIFICATION",
            // Class 3D — Invalid Catalog Name
            '3D000' : "INVALID CATALOG NAME",
            // Class 3F — Invalid Schema Name
            '3F000' : "INVALID SCHEMA NAME",
            // Class 40 — Transaction Rollback
            '40000' : "TRANSACTION ROLLBACK",
            '40002' : "TRANSACTION INTEGRITY CONSTRAINT VIOLATION",
            '40001' : "SERIALIZATION FAILURE",
            '40003' : "STATEMENT COMPLETION UNKNOWN",
            '40P01' : "DEADLOCK DETECTED",
            // Class 42 — Syntax Error or Access Rule Violation
            '42000' : "SYNTAX ERROR OR ACCESS RULE VIOLATION",
            '42601' : "SYNTAX ERROR",
            '42501' : "INSUFFICIENT PRIVILEGE",
            '42846' : "CANNOT COERCE",
            '42803' : "GROUPING ERROR",
            '42P20' : "WINDOWING ERROR",
            '42P19' : "INVALID RECURSION",
            '42830' : "INVALID FOREIGN KEY",
            '42602' : "INVALID NAME",
            '42622' : "NAME TOO LONG",
            '42939' : "RESERVED NAME",
            '42804' : "DATATYPE MISMATCH",
            '42P18' : "INDETERMINATE DATATYPE",
            '42809' : "WRONG OBJECT TYPE",
            '42703' : "UNDEFINED COLUMN",
            '42883' : "UNDEFINED FUNCTION",
            '42P01' : "UNDEFINED TABLE",
            '42P02' : "UNDEFINED PARAMETER",
            '42704' : "UNDEFINED OBJECT",
            '42701' : "DUPLICATE COLUMN",
            '42P03' : "DUPLICATE CURSOR",
            '42P04' : "DUPLICATE DATABASE",
            '42723' : "DUPLICATE FUNCTION",
            '42P05' : "DUPLICATE PREPARED STATEMENT",
            '42P06' : "DUPLICATE SCHEMA",
            '42P07' : "DUPLICATE TABLE",
            '42712' : "DUPLICATE ALIAS",
            '42710' : "DUPLICATE OBJECT",
            '42702' : "AMBIGUOUS COLUMN",
            '42725' : "AMBIGUOUS FUNCTION",
            '42P08' : "AMBIGUOUS PARAMETER",
            '42P09' : "AMBIGUOUS ALIAS",
            '42P10' : "INVALID COLUMN REFERENCE",
            '42611' : "INVALID COLUMN DEFINITION",
            '42P11' : "INVALID CURSOR DEFINITION",
            '42P12' : "INVALID DATABASE DEFINITION",
            '42P13' : "INVALID FUNCTION DEFINITION",
            '42P14' : "INVALID PREPARED STATEMENT DEFINITION",
            '42P15' : "INVALID SCHEMA DEFINITION",
            '42P16' : "INVALID TABLE DEFINITION",
            '42P17' : "INVALID OBJECT DEFINITION",
            // Class 44 — WITH 'CHECK' : "OPTION V",
            '44000' : "WITH CHECK OPTION VIOLATION",
            // Class 53 — Insufficient Resources
            '53000' : "INSUFFICIENT RESOURCES",
            '53100' : "DISK FULL",
            '53200' : "OUT OF MEMORY",
            '53300' : "TOO MANY CONNECTIONS",
            // Class 54 — Program Limit Exceeded
            '54000' : "PROGRAM LIMIT EXCEEDED",
            '54001' : "STATEMENT TOO COMPLEX",
            '54011' : "TOO MANY COLUMNS",
            '54023' : "TOO MANY ARGUMENTS",
            // Class 55 — Object Not In Prerequisite State
            '55000' : "OBJECT NOT IN PREREQUISITE STATE",
            '55006' : "OBJECT IN USE",
            '55P02' : "CANT CHANGE RUNTIME PARAM",
            '55P03' : "LOCK NOT AVAILABLE",
            // Class 57 — Operator Intervention
            '57000' : "OPERATOR INTERVENTION",
            '57014' : "QUERY CANCELED",
            '57P01' : "ADMIN SHUTDOWN",
            '57P02' : "CRASH SHUTDOWN",
            '57P03' : "CANNOT CONNECT NOW",
            // Class 58 — System Error (errors external to PostgreSQL itself)
            '58030' : "IO ERROR",
            '58P01' : "UNDEFINED FILE",
            '58P02' : "DUPLICATE FILE",
            // Class F0 — Configuration File Error
            'F0000' : "CONFIG FILE ERROR",
            'F0001' : "LOCK FILE EXISTS",
            // Class P0 — PL/pgSQL Error
            'P0000' : "PLPGSQL ERROR",
            'P0001' : "RAISE EXCEPTION",
            'P0002' : "NO DATA FOUND",
            'P0003' : "TOO MANY ROWS",
            // Class XX — Internal Error
            'XX000' : "INTERNAL ERROR",
            'XX001' : "DATA CORRUPTED",
            'XX002' : "INDEX CORRUPTED"
        };

        // Class 00 — Successful Completion
        public static const SUCCESSFUL_COMPLETION:String = "00000";
        // Class 01 — Warning
        public static const WARNING:String = "01000";
        public static const DYNAMIC_RESULT_SETS_RETURNED:String = "0100C";
        public static const IMPLICIT_ZERO_BIT_PADDING:String = "01008";
        public static const NULL_VALUE_ELIMINATED_IN_SET_FUNCTION:String = "01003";
        public static const PRIVILEGE_NOT_GRANTED:String = "01007";
        public static const PRIVILEGE_NOT_REVOKED:String = "01006";
        public static const STRING_DATA_RIGHT_TRUNCATION:String = "01004";
        public static const DEPRECATED_FEATURE:String = "01P01";
        // Class 02 — No Data (this is also a warning class per the SQL standard)
        public static const NO_DATA:String = "02000";
        public static const NO_ADDITIONAL_DYNAMIC_RESULT_SETS_RETURNED:String = "02001";
        // Class 03 — SQL_Statement Not Yet Complete
        public static const SQL_STATEMENT_NOT_YET_COMPLETE:String = "03000";
        // Class 08 — Connection Exception
        public static const CONNECTION_EXCEPTION:String = "08000";
        public static const CONNECTION_DOES_NOT_EXIST:String = "08003";
        public static const CONNECTION_FAILURE:String = "08006";
        public static const SQLCLIENT_UNABLE_TO_ESTABLISH_SQLCONNECTION:String = "08001";
        public static const SQLSERVER_REJECTED_ESTABLISHMENT_OF_SQLCONNECTION:String = "08004";
        public static const TRANSACTION_RESOLUTION_UNKNOWN:String = "08007";
        public static const PROTOCOL_VIOLATION:String = "08P01";
        // Class 09 — Triggered Action Exception
        public static const TRIGGERED_ACTION_EXCEPTION:String = "09000";
        // Class 0A — Feature Not Supported
        public static const FEATURE_NOT_SUPPORTED:String = "0A000";
        // Class 0B — Invalid Transaction Initiation
        public static const INVALID_TRANSACTION_INITIATION:String = "0B000";
        // Class 0F — Locator Exception
        public static const LOCATOR_EXCEPTION:String = "0F000";
        public static const INVALID_LOCATOR_SPECIFICATION:String = "0F001";
        // Class 0L — Invalid Grantor
        public static const INVALID_GRANTOR:String = "0L000";
        public static const INVALID_GRANT_OPERATION:String = "0LP01";
        // Class 0P — Invalid Role Specification
        public static const INVALID_ROLE_SPECIFICATION:String = "0P000";
        // Class 20 — Case Not Found
        public static const CASE_NOT_FOUND:String = "20000";
        // Class 21 — Cardinality Violation
        public static const CARDINALITY_VIOLATION:String = "21000";
        // Class 22 — Data Exception
        public static const DATA_EXCEPTION:String = "22000";
        public static const ARRAY_SUBSCRIPT_ERROR:String = "2202E";
        public static const CHARACTER_NOT_IN_REPERTOIRE:String = "22021";
        public static const DATETIME_FIELD_OVERFLOW:String = "22008";
        public static const DIVISION_BY_ZERO:String = "22012";
        public static const ERROR_IN_ASSIGNMENT:String = "22005";
        public static const ESCAPE_CHARACTER_CONFLICT:String = "2200B";
        public static const INDICATOR_OVERFLOW:String = "22022";
        public static const INTERVAL_FIELD_OVERFLOW:String = "22015";
        public static const INVALID_ARGUMENT_FOR_LOGARITHM:String = "2201E";
        public static const INVALID_ARGUMENT_FOR_NTILE_FUNCTION:String = "22014";
        public static const INVALID_ARGUMENT_FOR_NTH:String = "22016";
        public static const INVALID_ARGUMENT_FOR_POWER_FUNCTION:String = "2201F";
        public static const INVALID_ARGUMENT_FOR_WIDTH_BUCKET_FUNCTION:String = "2201G";
        public static const INVALID_CHARACTER_VALUE_FOR_CAST:String = "22018";
        public static const INVALID_DATETIME_FORMAT:String = "22007";
        public static const INVALID_ESCAPE_CHARACTER:String = "22019";
        public static const INVALID_ESCAPE_OCTET:String = "2200D";
        public static const INVALID_ESCAPE_SEQUENCE:String = "22025";
        public static const NONSTANDARD_USE_OF_ESCAPE_CHARACTER:String = "22P06";
        public static const INVALID_INDICATOR_PARAMETER_VALUE:String = "22010";
        public static const INVALID_PARAMETER_VALUE:String = "22023";
        public static const INVALID_REGULAR_EXPRESSION:String = "2201B";
        public static const INVALID_ROW_COUNT_IN_LIMIT_CLAUSE:String = "2201W";
        public static const INVALID_ROW_COUNT_IN_RESULT_OFFSET_CLAUSE:String = "2201X";
        public static const INVALID_TIME_ZONE_DISPLACEMENT_VALUE:String = "22009";
        public static const INVALID_USE_OF_ESCAPE_CHARACTER:String = "2200C";
        public static const MOST_SPECIFIC_TYPE_MISMATCH:String = "2200G";
        public static const NULL_VALUE_NOT_ALLOWED:String = "22004";
        public static const NULL_VALUE_NO_INDICATOR_PARAMETER:String = "22002";
        public static const NUMERIC_VALUE_OUT_OF_RANGE:String = "22003";
        public static const STRING_DATA_LENGTH_MISMATCH:String = "22026";
        public static const DATA_STRING_DATA_RIGHT_TRUNCATION:String = "22001";
        public static const SUBSTRING_ERROR:String = "22011";
        public static const TRIM_ERROR:String = "22027";
        public static const UNTERMINATED_C_STRING:String = "22024";
        public static const ZERO_LENGTH_CHARACTER_STRING:String = "2200F";
        public static const FLOATING_POINT_EXCEPTION:String = "22P01";
        public static const INVALID_TEXT_REPRESENTATION:String = "22P02";
        public static const INVALID_BINARY_REPRESENTATION:String = "22P03";
        public static const BAD_COPY_FILE_FORMAT:String = "22P04";
        public static const UNTRANSLATABLE_CHARACTER:String = "22P05";
        public static const NOT_AN_XML_DOCUMENT:String = "2200L";
        public static const INVALID_XML_DOCUMENT:String = "2200M";
        public static const INVALID_XML_CONTENT:String = "2200N";
        public static const INVALID_XML_COMMENT:String = "2200S";
        public static const INVALID_XML_PROCESSING_INSTRUCTION:String = "2200T";
        // Class 23 — Integrity Constraint Violation
        public static const INTEGRITY_CONSTRAINT_VIOLATION:String = "23000";
        public static const RESTRICT_VIOLATION:String = "23001";
        public static const NOT_NULL_VIOLATION:String = "23502";
        public static const FOREIGN_KEY_VIOLATION:String = "23503";
        public static const UNIQUE_VIOLATION:String = "23505";
        public static const CHECK_VIOLATION:String = "23514";
        // Class 24 — Invalid Cursor State
        public static const INVALID_CURSOR_STATE:String = "24000";
        // Class 25 — Invalid Transaction State
        public static const INVALID_TRANSACTION_STATE:String = "25000";
        public static const ACTIVE_SQL_TRANSACTION:String = "25001";
        public static const BRANCH_TRANSACTION_ALREADY_ACTIVE:String = "25002";
        public static const HELD_CURSOR_REQUIRES_SAME_ISOLATION_LEVEL:String = "25008";
        public static const INAPPROPRIATE_ACCESS_MODE_FOR_BRANCH_TRANSACTION:String = "25003";
        public static const INAPPROPRIATE_ISOLATION_LEVEL_FOR_BRANCH_TRANSACTION:String = "25004";
        public static const NO_ACTIVE_SQL_TRANSACTION_FOR_BRANCH_TRANSACTION:String = "25005";
        public static const READ_ONLY_SQL_TRANSACTION:String = "25006";
        public static const SCHEMA_AND_DATA_STATEMENT_MIXING_NOT_SUPPORTED:String = "25007";
        public static const NO_ACTIVE_SQL_TRANSACTION:String = "25P01";
        public static const IN_FAILED_SQL_TRANSACTION:String = "25P02";
        // Class 26 — Invalid SQL_Statement Name
        public static const INVALID_SQL_STATEMENT_NAME:String = "26000";
        // Class 27 — Triggered Data Change Violation
        public static const TRIGGERED_DATA_CHANGE_VIOLATION:String = "27000";
        // Class 28 — Invalid Authorization Specification
        public static const INVALID_AUTHORIZATION_SPECIFICATION:String = "28000";
        // Class 2B — Dependent Privilege Descriptors Still Exist
        public static const DEPENDENT_PRIVILEGE_DESCRIPTORS_STILL_EXIST:String = "2B000";
        public static const DEPENDENT_OBJECTS_STILL_EXIST:String = "2BP01";
        // Class 2D — Invalid Transaction Termination
        public static const INVALID_TRANSACTION_TERMINATION:String = "2D000";
        // Class 2F — SQL_Routine Exception
        public static const SQL_ROUTINE_EXCEPTION:String = "2F000";
        public static const FUNCTION_EXECUTED_NO_RETURN_STATEMENT:String = "2F005";
        public static const MODIFYING_SQL_DATA_NOT_PERMITTED:String = "2F002";
        public static const PROHIBITED_SQL_STATEMENT_ATTEMPTED:String = "2F003";
        public static const READING_SQL_DATA_NOT_PERMITTED:String = "2F004";
        // Class 34 — Invalid Cursor Name
        public static const INVALID_CURSOR_NAME:String = "34000";
        // Class 38 — External Routine Exception
        public static const EXTERNAL_ROUTINE_EXCEPTION:String = "38000";
        public static const CONTAINING_SQL_NOT_PERMITTED:String = "38001";
        public static const EXTERNAL_MODIFYING_SQL_DATA_NOT_PERMITTED:String = "38002";
        public static const EXTERNAL_PROHIBITED_SQL_STATEMENT_ATTEMPTED:String = "38003";
        public static const EXTERNAL_READING_SQL_DATA_NOT_PERMITTED:String = "38004";
        // Class 39 — External Routine Invocation Exception
        public static const EXTERNAL_ROUTINE_INVOCATION_EXCEPTION:String = "39000";
        public static const INVALID_SQLSTATE_RETURNED:String = "39001";
        public static const EXTERNAL_NULL_VALUE_NOT_ALLOWED:String = "39004";
        public static const TRIGGER_PROTOCOL_VIOLATED:String = "39P01";
        public static const SRF_PROTOCOL_VIOLATED:String = "39P02";
        // Class 3B — Savepoint Exception
        public static const SAVEPOINT_EXCEPTION:String = "3B000";
        public static const INVALID_SAVEPOINT_SPECIFICATION:String = "3B001";
        // Class 3D — Invalid Catalog Name
        public static const INVALID_CATALOG_NAME:String = "3D000";
        // Class 3F — Invalid Schema Name
        public static const INVALID_SCHEMA_NAME:String = "3F000";
        // Class 40 — Transaction Rollback
        public static const TRANSACTION_ROLLBACK:String = "40000";
        public static const TRANSACTION_INTEGRITY_CONSTRAINT_VIOLATION:String = "40002";
        public static const SERIALIZATION_FAILURE:String = "40001";
        public static const STATEMENT_COMPLETION_UNKNOWN:String = "40003";
        public static const DEADLOCK_DETECTED:String = "40P01";
        // Class 42 — Syntax Error or Access Rule Violation
        public static const SYNTAX_ERROR_OR_ACCESS_RULE_VIOLATION:String = "42000";
        public static const SYNTAX_ERROR:String = "42601";
        public static const INSUFFICIENT_PRIVILEGE:String = "42501";
        public static const CANNOT_COERCE:String = "42846";
        public static const GROUPING_ERROR:String = "42803";
        public static const WINDOWING_ERROR:String = "42P20";
        public static const INVALID_RECURSION:String = "42P19";
        public static const INVALID_FOREIGN_KEY:String = "42830";
        public static const INVALID_NAME:String = "42602";
        public static const NAME_TOO_LONG:String = "42622";
        public static const RESERVED_NAME:String = "42939";
        public static const DATATYPE_MISMATCH:String = "42804";
        public static const INDETERMINATE_DATATYPE:String = "42P18";
        public static const WRONG_OBJECT_TYPE:String = "42809";
        public static const UNDEFINED_COLUMN:String = "42703";
        public static const UNDEFINED_FUNCTION:String = "42883";
        public static const UNDEFINED_TABLE:String = "42P01";
        public static const UNDEFINED_PARAMETER:String = "42P02";
        public static const UNDEFINED_OBJECT:String = "42704";
        public static const DUPLICATE_COLUMN:String = "42701";
        public static const DUPLICATE_CURSOR:String = "42P03";
        public static const DUPLICATE_DATABASE:String = "42P04";
        public static const DUPLICATE_FUNCTION:String = "42723";
        public static const DUPLICATE_PREPARED_STATEMENT:String = "42P05";
        public static const DUPLICATE_SCHEMA:String = "42P06";
        public static const DUPLICATE_TABLE:String = "42P07";
        public static const DUPLICATE_ALIAS:String = "42712";
        public static const DUPLICATE_OBJECT:String = "42710";
        public static const AMBIGUOUS_COLUMN:String = "42702";
        public static const AMBIGUOUS_FUNCTION:String = "42725";
        public static const AMBIGUOUS_PARAMETER:String = "42P08";
        public static const AMBIGUOUS_ALIAS:String = "42P09";
        public static const INVALID_COLUMN_REFERENCE:String = "42P10";
        public static const INVALID_COLUMN_DEFINITION:String = "42611";
        public static const INVALID_CURSOR_DEFINITION:String = "42P11";
        public static const INVALID_DATABASE_DEFINITION:String = "42P12";
        public static const INVALID_FUNCTION_DEFINITION:String = "42P13";
        public static const INVALID_PREPARED_STATEMENT_DEFINITION:String = "42P14";
        public static const INVALID_SCHEMA_DEFINITION:String = "42P15";
        public static const INVALID_TABLE_DEFINITION:String = "42P16";
        public static const INVALID_OBJECT_DEFINITION:String = "42P17";
        // Class 44 — WITH_CHECK_OPTION_Violation
        public static const WITH_CHECK_OPTION_VIOLATION:String = "44000";
        // Class 53 — Insufficient Resources
        public static const INSUFFICIENT_RESOURCES:String = "53000";
        public static const DISK_FULL:String = "53100";
        public static const OUT_OF_MEMORY:String = "53200";
        public static const TOO_MANY_CONNECTIONS:String = "53300";
        // Class 54 — Program Limit Exceeded
        public static const PROGRAM_LIMIT_EXCEEDED:String = "54000";
        public static const STATEMENT_TOO_COMPLEX:String = "54001";
        public static const TOO_MANY_COLUMNS:String = "54011";
        public static const TOO_MANY_ARGUMENTS:String = "54023";
        // Class 55 — Object Not In Prerequisite State
        public static const OBJECT_NOT_IN_PREREQUISITE_STATE:String = "55000";
        public static const OBJECT_IN_USE:String = "55006";
        public static const CANT_CHANGE_RUNTIME_PARAM:String = "55P02";
        public static const LOCK_NOT_AVAILABLE:String = "55P03";
        // Class 57 — Operator Intervention
        public static const OPERATOR_INTERVENTION:String = "57000";
        public static const QUERY_CANCELED:String = "57014";
        public static const ADMIN_SHUTDOWN:String = "57P01";
        public static const CRASH_SHUTDOWN:String = "57P02";
        public static const CANNOT_CONNECT_NOW:String = "57P03";
        // Class 58 — System Error (errors external to PostgreSQL itself)
        public static const IO_ERROR:String = "58030";
        public static const UNDEFINED_FILE:String = "58P01";
        public static const DUPLICATE_FILE:String = "58P02";
        // Class F0 — Configuration File Error
        public static const CONFIG_FILE_ERROR:String = "F0000";
        public static const LOCK_FILE_EXISTS:String = "F0001";
        // Class P0 — PL/pgSQL_Error
        public static const PLPGSQL_ERROR:String = "P0000";
        public static const RAISE_EXCEPTION:String = "P0001";
        public static const NO_DATA_FOUND:String = "P0002";
        public static const TOO_MANY_ROWS:String = "P0003";
        // Class XX — Internal Error
        public static const INTERNAL_ERROR:String = "XX000";
        public static const DATA_CORRUPTED:String = "XX001";
        public static const INDEX_CORRUPTED:String = "XX002";
    }
}