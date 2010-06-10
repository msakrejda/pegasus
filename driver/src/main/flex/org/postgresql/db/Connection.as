package org.postgresql.db {

    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;
    
    import org.postgresql.codec.CodecFactory;
    import org.postgresql.event.NoticeEvent;
    import org.postgresql.event.NotificationEvent;
    import org.postgresql.febe.FEBEConnection;
    import org.postgresql.febe.MessageBroker;

    public class Connection extends EventDispatcher {

        private var _codecs:CodecFactory;
        private var _baseConn:FEBEConnection;

        private var _params:Object;
        private var _broker:MessageBroker;

        private var _active:Dictionary;
        private var _pendingExecution:Array;

        // query handler factory instead of CodecFactory--codecs are
        // only used for handlers
        public function Connection(baseConn:FEBEConnection, codecs:CodecFactory) {
            _baseConn = baseConn;
            _codecs = codecs;

            // add listeners to the baseConn for rfq, paramStatus, notice / error / notification
            _baseConn.addEventListener(FEBEConnection.READY_FOR_QUERY, handleRfq);

            // Unfortunately, our two-tiered approach here means there are a number of
            // events the base connection dispatches that we just want to rebroadcast
            // directly--we do this by cloning them...            
            _baseConn.addEventListener(FEBEConnection.PARAM_CHANGE, handleRebroadcast);
            _baseConn.addEventListener(FEBEConnection.CONNECTED, handleRebroadcast);
            _baseConn.addEventListener(NoticeEvent.NOTICE, handleRebroadcast);
            _baseConn.addEventListener(NoticeEvent.ERROR, handleRebroadcast);
            _baseConn.addEventListener(NotificationEvent.NOTIFICATION, handleRebroadcast);
            
            // support, {simple,extended}QueryExecutor, copy, function call, cancel, terminate

            _active = new Dictionary();
            _pendingExecution = [];
        }

        private function handleRebroadcast(e:Event):void {
        	var newEvent:Event = e.clone();
        	dispatchEvent(newEvent);
        }


        private function handleRfq(e:Event):void {
        	if (_pendingExecution.length > 0) {
        		var nextQuery:Object = _pendingExecution.shift();
        		_baseConn.executeSimpleQuery(nextQuery.sql,
                    new DefaultQueryHandler(nextQuery.statement, _codecs));
        	}
        }
        
        internal function cancelStatement(stmt:IStatement):void {
            
        }

        public function createStatement():IStatement {
            var s:IStatement = new SimpleStatement(this);
            _active[s] = true;
            return s;
        }
        
        public function close():void {
            _baseConn.close();
        }

        internal function executeQuery(statement:IStatement, sql:String):void {
            if (!(statement in _active)) {
                throw new ArgumentError("Attempting to execute unregistered statement: " + statement);
            }

            if (_baseConn.rfq) {
                _baseConn.executeSimpleQuery(sql, new DefaultQueryHandler(statement, _codecs));   
            } else {
                _pendingExecution.push({ statement: statement, sql: sql });
            }
        }

        internal function closeStatement(statement:IStatement):void {
            if (!(statement in _active)) {
                throw new ArgumentError("Attempting to close unregistered statement: " + statement);
            }
            // TODO: Send close for portal / statement
            delete _active[statement];
        }


    }
}

import org.postgresql.febe.IQueryHandler;
import org.postgresql.codec.CodecFactory;
import org.postgresql.db.IStatement;
import org.postgresql.febe.FieldDescription;
import flash.utils.ByteArray;

class DefaultQueryHandler implements IQueryHandler {

	private var _codecFactory:CodecFactory;
	private var _stmt:IStatement;
	private var _fields:Array;
	private var _decoders:Array;

    private var _data:Array;

	public function DefaultQueryHandler(stmt:IStatement, codecs:CodecFactory) {
		_stmt = stmt;
		_codecFactory = codecs;
		_data = [];
	}

    public function handleMetadata(fields:Array):void {
    	_fields = fields;
    	_decoders = [];
    	for each (var f:FieldDescription in fields) {
    		_decoders.push(_codecFactory.getDecoder(f.typeOid));
    	}
    }

    public function handleData(rows:Array, serverParams:Object):void {
    	// TODO: handle streaming
    	for each (var row:Array in rows) {
    		var decodedRow:Array = [];
    		for (var i:int = 0; i < row.length; i++) { 
    			if (row[i]) {
    				// TODO: this needs access to serverParams
    				decodedRow.push(_decoders[i].decode(row[i], _fields[i], serverParams));
    			} else {
    				decodedRow.push(null);
    			}
    		}
    		_data.push(decodedRow);
    	}
    }

    public function handleCompletion(command:String, rows:int=0, oid:int=-1):void {
    	for each (var row:Array in _data) {
    		trace (row.join(','));
    	}
    	trace('complete');
    }

    public function handleNotice(fields:Object):void {
    	
    }

    public function handleError(fields:Object):void {
    	
    }
}