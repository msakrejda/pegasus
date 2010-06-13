package org.postgresql.febe {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.postgresql.event.NoticeEvent;
	import org.postgresql.event.NotificationEvent;
	import org.postgresql.febe.message.AuthenticationRequest;
	import org.postgresql.febe.message.BackendKeyData;
	import org.postgresql.febe.message.CancelRequest;
	import org.postgresql.febe.message.CommandComplete;
	import org.postgresql.febe.message.DataRow;
	import org.postgresql.febe.message.EmptyQueryResponse;
	import org.postgresql.febe.message.ErrorResponse;
	import org.postgresql.febe.message.IBEMessage;
	import org.postgresql.febe.message.NoticeResponse;
	import org.postgresql.febe.message.NotificationResponse;
	import org.postgresql.febe.message.ParameterStatus;
	import org.postgresql.febe.message.PasswordMessage;
	import org.postgresql.febe.message.Query;
	import org.postgresql.febe.message.ReadyForQuery;
	import org.postgresql.febe.message.ResponseMessageBase;
	import org.postgresql.febe.message.RowDescription;
	import org.postgresql.febe.message.StartupMessage;
	import org.postgresql.febe.message.Terminate;
	import org.postgresql.log.ILogger;
	import org.postgresql.log.Log;

    // A FEBEConnection can execute one statement at a time (when it is rfq).
    // It does not do any parameter encoding or result set decoding: these
    // are passed through as binary payloads, with decoding to be done at
    // a higher level.
	public class FEBEConnection {

        private static const LOGGER:ILogger = Log.getLogger(FEBEConnection);

		private var _params:Object;

        private var _brokerFactory:MessageBrokerFactory;
		private var _broker:MessageBroker;

        private var _authenticated:Boolean;
        private var _connecting:Boolean;
        private var _connected:Boolean;

        private var _rfq:Boolean;
        private var _status:String;

        private var _queryHandler:IQueryHandler;
        private var _currResults:Array;

        private var _password:String;
        
        private var _connHandler:IConnectionHandler;

	    private var _backendPid:int;
	    private var _backendKey:int;
	
	    public var serverParams:Object;


        // Note that params here are params we want to send to the server in the
        // startup packet. The jdbc driver sends this:
        // {
        //      user: user,
        //      database: database,
        //      client_encoding: "UNICODE",
        //      DateStyle: "ISO"
        // };
        // Furthermore, we need the password if we're doing authentication that
        // involves a password. Jdbc also passes in a flag to use SSL here, but
        // it could be handy to handle that in the message broker factory

		public function FEBEConnection(params:Object, password:String, brokerFactory:MessageBrokerFactory) {
			_params = params;
            _brokerFactory = brokerFactory;

            _connected = false;
            _connecting = false;
            _authenticated = false;

            _queryHandler = null;
            _currResults = [];
            
            _password = password;

            serverParams = {};
            _backendKey = -1;
            _backendPid = -1;
		}

        public function get rfq():Boolean {
        	return _rfq;
        }

        public function get status():String {
        	return _status;
        }

        public function connect(handler:IConnectionHandler):void {
        	_connHandler = handler;

            _broker = _brokerFactory.create();
            // TODO: This is a little ugly, especially since the underlying
            // data stream can theoretically give up the ghost before this
            // step happens. In practice, that's not likely due to Flash
            // Player's asynchronous execution model, but it'd be nice to fix.
            // It's also ugly to just pass a raw function here.
            _broker.disconnectHandler = _connHandler.handleConnectionDrop;

        	_broker.setMessageListener(AuthenticationRequest, handleAuth);
        	_broker.setMessageListener(BackendKeyData, handleKeyData);
        	_broker.setMessageListener(ParameterStatus, handleParam);
        	_broker.setMessageListener(NoticeResponse, handleNotice);
        	_broker.setMessageListener(ErrorResponse, handleError);
        	_broker.setMessageListener(ReadyForQuery, handleFirstRfq);

        	_broker.addEventListener(MessageBroker.BATCH_COMPLETE, handleBatchComplete);

            _broker.send(new StartupMessage(_params));
        }

        private function handleUnexpectedMessage(msg:IBEMessage):void {
            // TODO: this should probably be an error event since it's happening asynchronously,
            // or just hand it off to the connection handler
        	throw new ProtocolError("Unexpected message: " + msg.type);
        }
	
	    private function handleAuth(msg:AuthenticationRequest):void {
	    	// TODO: more auth types
	        if (msg.subtype == AuthenticationRequest.OK) {
	            _authenticated = true;
	        } else if (msg.subtype == AuthenticationRequest.CLEARTEXT_PASSWORD) {
	            _broker.send(new PasswordMessage(_password));
	        } else {
	        	// TODO: see above
	            throw new UnsupportedProtocolFeatureError("Unsupported authentication type requested: " + msg.subtype);                   
	        }
	    }

        private function handleFirstRfq(msg:ReadyForQuery):void {
            if (_authenticated) {
                _connecting = false;
                _connected = true;
                _rfq = true;
                _status = msg.status;

                _broker.setMessageListener(ReadyForQuery, handleRfq);
                _broker.setMessageListener(AuthenticationRequest, handleUnexpectedMessage);
                _broker.setMessageListener(BackendKeyData, handleUnexpectedMessage);

                _broker.setMessageListener(NotificationResponse, handleNotification);
                _broker.setMessageListener(RowDescription, handleMetadata);
                _broker.setMessageListener(DataRow, handleData);
                // _broker.setMessageListener(CopyInResponse, ...);
                // _broker.setMessageListener(CopyOutResponse, ...);
                _broker.setMessageListener(CommandComplete, handleComplete);
                _broker.setMessageListener(EmptyQueryResponse, handleEmpty);

                _connHandler.handleRfq();
                _connHandler.handleConnected();
            } else {
                throw new ProtocolError("Unexpected ReadyForQuery without AuthenticationOK"); 
            }
        }
	
	    private function handleKeyData(msg:BackendKeyData):void {
	        _backendKey = msg.key;
	        _backendPid = msg.pid;
	    }
	
	    private function handleParam(msg:ParameterStatus):void {
	        serverParams[msg.name] = msg.value;
	        if (_connected) {
	           _connHandler.handleParameterChange(msg.name, msg.value);
	        }
	    }
	
	    private function handleRfq(msg:ReadyForQuery):void {
	        _rfq = true;
	        _status = msg.status;
	        _connHandler.handleRfq();
	    }
	
	    private function handleNotification(msg:NotificationResponse):void {
	    	_connHandler.handleNotification(msg.condition, msg.notifierPid);
	    }
	
	    private function handleNotice(msg:ResponseMessageBase):void {
	    	if (_queryHandler) {
    			_queryHandler.handleNotice(msg.fields);
	    	} else {
	    		_connHandler.handleNotice(msg.fields);
            }
	    }

        private function handleError(msg:ErrorResponse):void {
            if (_queryHandler) {
                _queryHandler.handleError(msg.fields);
            } else {
				LOGGER.debug("Non-query error:");
                for (var key:String in msg.fields) {
                    LOGGER.debug(key, msg.fields[key]);
                }
                _connHandler.handleError(msg.fields);
            }        	
        }
	
	    private function handleMetadata(msg:RowDescription):void {
	        if (_queryHandler) {
	        	_queryHandler.handleMetadata(msg.fields);
	        } else {
	        	throw new ProtocolError('Unexpected RowDescription message');
	        }
	    }
	
	    private function handleData(msg:DataRow):void {
	        if (_queryHandler) {
	        	_currResults.push(msg.rowBytes);
	        } else {
	        	throw new ProtocolError('Unexpected DataRow message');
	        }
	    }
	
	    private function handleComplete(msg:CommandComplete):void {
	        if (_queryHandler) {
	        	flushPendingResults();
	        	_queryHandler.handleCompletion(msg.command, msg.affectedRows, msg.oid);
	        	_queryHandler = null;
	        } else {
	        	throw new ProtocolError("Unexpected CommandComplete"); 
	        }
	    }
	
	    private function handleEmpty(msg:EmptyQueryResponse):void {
	        // This is equivalent to CommandComplete when an empty query completes.
	        // Let's call this a query completing successfully. Theoretically, we may want
	        // to handle this differently, but there's little practical use for that.
	        if (_queryHandler) {
	        	_queryHandler.handleCompletion('EMPTY QUERY');
	        	_currResults = [];
	        	_queryHandler = null;
	        } else {
	        	throw new ProtocolError("Unexpected EmptyQueryResponse");
	        }
	    }

        private function flushPendingResults():void {
            if (_queryHandler && _currResults.length > 0) {
                _queryHandler.handleData(_currResults, serverParams);
                _currResults = [];
            }
        }

        private function handleBatchComplete(e:Event):void {
        	flushPendingResults();
        }

        // Methods executeSimpleQuery and executeQuery should both notify caller when commandComplete
        // returns a result set. When rfq, the nesting Connection should issue another query.

        // Since these will only have one outstanding statement at any given time, perhaps
        // we should keep that as a member variable while the call is being executed. We
        // need to have some concept of 'outstanding statement' (which could lead to more
        // than one result set for a simple query), and we still need to process notices
        // and notifications while this happens. We also need to figure out what events
        // to dispatch in this case.

        // To future-proof against result set streaming, we should dispatch separate
        // query-data-available and statement-complete messages. We should also batch
        // the data-available messages--dispatching an event per-DataRow would be silly.
        public function executeSimpleQuery(sql:String, handler:IQueryHandler):void {
        	if (!_rfq) {
        		throw new ArgumentError("FEBEConnection is not ready for query");
        	}
            _queryHandler = handler;
            _broker.send(new Query(sql));
        }

        public function executeQuery(sql:String, params:Array, handler:IQueryHandler):void {
        	// > parse(statement)
        	// < parseComplete | errorResponse
        	// > bind(portal)
        	// < bindComplete | errorResponse
        	// > describe(portal)
        	// < rowDescription
        	// > execute(portal)
        	// < commandComplete | errorResponse | emptyQueryResponse | portalSuspended
        	// > sync
        }

        // additionally, there is fastpath (function call) and copy. It might be handy to
        // support a structured explain

        public function cancel():void {
        	// Note that cancel needs to happen in a separate connection to make any sense
        	var cancelBroker:MessageBroker = _brokerFactory.create();
        	cancelBroker.send(new CancelRequest(_backendPid, _backendKey));
        	cancelBroker.close();
        }

        public function close():void {
            if (_connected) {
                _broker.send(new Terminate());
                _broker.close();
                _connected = false;
            }
        }

	}
}