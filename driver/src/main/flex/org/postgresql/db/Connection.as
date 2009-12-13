package org.postgresql.db {

    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    
    import org.postgresql.codec.TypeCodecFactory;
    import org.postgresql.febe.FEBEConnection;
    import org.postgresql.febe.MessageBroker;

    public class Connection extends EventDispatcher {

        private var _codecs:TypeCodecFactory;
        private var _baseConn:FEBEConnection;

        private var _params:Object;
        private var _broker:MessageBroker;

        private var _active:Dictionary;
        private var _pendingExecution:Array;
        private var _pendingResult:Array;

        public function Connection(baseConn:FEBEConnection, codecs:TypeCodecFactory) {
            _baseConn = baseConn;
            _codecs = codecs;

            // add listeners to the broker for rfq, auth handling, paramStatus, backendKeyData,
            // rowDescription, dataRow, commandComplete

            // authenticator, {simple,extended}QueryExecutor, copy, function call, cancel, terminate

            // Authentication

            // Notification

            // Notice / Error

            // Query

            // Copy

            _active = new Dictionary();
            _pendingExecution = [];
            _pendingResult = [];
        }

        public function createStatement():IStatement {
            var s:IStatement = new SimpleStatement(this);
            _active[s] = true;
            return s;
        }

        internal function executeQuery(statement:IStatement, sql:String):void {
            if (!(statement in _active)) {
                throw new ArgumentError("Attempting to execute unregistered statement: " + statement);
            }

            if (_baseConn.rfq) {
            	// TODO: what is the proper API here? should _baseConn track the
            	// statement, or Connection?
                //_baseConn.execute(sql, statement);
                _pendingResult.push({ statement: statement, sql: sql });
            } else {
                _pendingExecution.push({ statement: statement, sql: sql });
            }
        }

        internal function closeStatement(statement:IStatement):void {
            if (!(statement in _active)) {
                throw new ArgumentError("Attempting to close unregistered statement: " + statement);
            }
            // Send close for portal / statement
            delete _active[statement];
        }


    }
}

import org.postgresql.febe.IQueryHandler;
import org.postgresql.codec.TypeCodecFactory;
import org.postgresql.db.IStatement;

class DefaultQueryHandler implements IQueryHandler {

	private var _codecFactory:TypeCodecFactory;
	private var _stmt:IStatement;
	private var _fields:Array;

	public function DefaultQueryHandler(codecs:TypeCodecFactory, stmt:IStatement) {
		_stmt = stmt;
		_codecFactory = codecs;
	}

    public function handleMetadata(fields:Array):void {
    	_fields = fields;
    }

    public function handleData(rows:Array):void {
    	//if (!_stmt.isStreaming) {
    		//_stmt.addRows(process(rows));
    	//}
    	//_stmt.dispatchEvent('data event');
    }

    public function handleCompletion(command:String, rows:int=0, oid:int=-1):void {
    	//_stmt.dispatchEvent('complete');
    }
}