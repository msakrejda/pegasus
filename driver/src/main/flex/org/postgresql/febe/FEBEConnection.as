package org.postgresql.febe {

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.postgresql.febe.message.IBEMessage;
	import org.postgresql.febe.message.Query;
	import org.postgresql.febe.message.ReadyForQuery;
	import org.postgresql.febe.message.StartupMessage;
	import org.postgresql.febe.message.Terminate;

    // A FEBEConnection can execute one statement at a time (when it is rfq).
    // It does not do any parameter encoding or result set decoding: these
    // are passed through as binary payloads, with decoding to be done at
    // a higher level.
	public class FEBEConnection extends EventDispatcher {

        private static const LOGGER:ILogger = Log.getLogger("org.postgresql.db.Connection");

		private var _params:Object;
		private var _broker:MessageBroker;

        private var _connecting:Boolean;
        private var _connected:Boolean;
        private var _handlers:Array;

        private var _msgDispatcher:IEventDispatcher;

        private var _queryHandler:QueryMessageHandler;
        private var _rfqHandler:ReadyForQueryHandler;

		public function FEBEConnection(params:Object, broker:MessageBroker) {
			_params = params;
			_broker = broker;

            _connected = false;
            _connecting = false;
            _handlers = [];

            _broker.addEventListener(MessageEvent.RECEIVED, handleMessageReceived);
		}

        public function get rfq():Boolean {
        	return _rfqHandler.rfq;
        }

        public function get transactionStatus():String {
        	return _rfqHandler.status;
        }

        public function connect(dispatcher:IEventDispatcher):void {
            _msgDispatcher = dispatcher;
            var authHandler:IFEBEMessageHandler = new AuthenticationHandler(dispatcher);
            authHandler.addEventListener(AuthenticationHandler.AUTHENTICATED, handleAuth);
            _handlers.push(authHandler);
            _broker.send(new StartupMessage(_params));
        }

        private function handleAuth(e:Event):void {
        	_connecting = false;
        	_connected = true;
        	//_queryHandler = new QueryMessageHandler(_msgDispatcher);
        	_handlers = [ /* query, rfq (?), notice/error, notification */ ];
        	// rfq probably does not need to be its own handler with its own state--we
        	// can directly add an event handler to the broker.
        }
		

        // executeSimpleQuery and executeQuery should both notify caller when commandComplete
        // returns a result set. when rfq, the nesting Connection should issue another query.

        // additionally, there is fastpath (function call) and copy. It might be handy to
        // support a structured explain

        // since these will only have one outstanding statement at any given time, perhaps
        // we should keep that as a member variable while the call is being executed. We
        // need to have some concept of 'outstanding statement' (which could lead to more
        // than one result set for a simple query), and we still need to process notices
        // and notifications while this happens. We also need to figure out what events
        // to dispatch in this case.

        // To future-proof against result set streaming, we should dispatch separate
        // query-data-available and statement-complete messages. We should also batch
        // the data-available messages--dispatching an event per-DataRow would be silly.
        internal function executeSimpleQuery(sql:String, handler:IQueryHandler):void {
            _broker.send(new Query(sql));
        }

        internal function executeQuery():void {
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

        public function close():void {
            if (_connected) {
                _broker.send(new Terminate());                
            }
        }

        private function handleMessageReceived(event:MessageEvent):void {
        	var msg:IBEMessage = event.message as IBEMessage;
            for each (var h:IFEBEMessageHandler in _handlers) {
                var callback:Function = h.getCallback(msg);
                if (callback != null) {
                    callback(msg);
                    return;
                }
            }
            // TODO: warn about unprocessed messages?
        }

	}
}


import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import flash.utils.Dictionary;

import org.postgresql.febe.message.IBEMessage;

interface IFEBEMessageHandler extends IEventDispatcher {
    function getCallback(msg:IBEMessage):Function;
}


/* abstract */ class AbstractFEBEMessageHandler
    extends EventDispatcher implements IFEBEMessageHandler {

    protected var _handlerMethods:Dictionary;

    public function AbstractFEBEMessageHandler(target:IEventDispatcher=null) {
        super(target);
        _handlerMethods = new Dictionary();
    }

    public function getCallback(msg:IBEMessage):Function {
        return _handlerMethods[Object(msg).constructor];
    }
}

import org.postgresql.febe.message.AuthenticationRequest;
import org.postgresql.febe.message.BackendKeyData;
import org.postgresql.febe.message.ParameterStatus;
import org.postgresql.febe.message.ReadyForQuery;

class AuthenticationHandler extends AbstractFEBEMessageHandler {

    public static const AUTHENTICATED:String = 'authenticated';
    
    public var backendPid:int;
    public var backendKey:int;

    public var serverParams:Object;

    private var _authenticated:Boolean;

    public function AuthenticationHandler(target:IEventDispatcher) {
        super(target);
        _handlerMethods[AuthenticationRequest] = handleAuth;
        _handlerMethods[BackendKeyData] = handleKeyData;
        _handlerMethods[ParameterStatus] = handleParam;
        _handlerMethods[ReadyForQuery] = handleInitialRfq;
        serverParams = {};
    }

    private function handleAuth(msg:AuthenticationRequest):void {
        if (msg.subtype == AuthenticationRequest.OK) {
            _authenticated = true;              
        } else {
            throw new ProtocolError("Unsupported authentication type requested");                   
        }
    }

    private function handleKeyData(msg:BackendKeyData):void {
        backendKey = msg.key;
        backendPid = msg.pid;
    }

    private function handleParam(msg:ParameterStatus):void {
        serverParams[msg.name] = msg.value;
    }

    private function handleInitialRfq(msg:ReadyForQuery):void {
        if (_authenticated) {
            dispatchEvent(new Event(AUTHENTICATED));
        } else {
            throw new ProtocolError("Unexpected ReadyForQuery before authentication");
        }
    }
}

import org.postgresql.febe.message.ReadyForQuery;

class ReadyForQueryHandler
    extends AbstractFEBEMessageHandler implements IFEBEMessageHandler {

    public var rfq:Boolean;
    public var status:String;

    public function ReadyForQueryHandler(target:IEventDispatcher) {
        super(target);
        _handlerMethods[ReadyForQuery] = handleRfq;
        rfq = false;
        status = TransactionStatus.IDLE;
    }

    private function handleRfq(msg:ReadyForQuery):void {
        rfq = true;
        status = msg.status;
    }    
}

import org.postgresql.db.IStatement;
import org.postgresql.febe.message.CommandComplete;
import org.postgresql.febe.message.DataRow;
import org.postgresql.febe.message.EmptyQueryResponse;
import org.postgresql.febe.message.RowDescription;

class QueryMessageHandler extends AbstractFEBEMessageHandler {

    private var _stmt:IStatement;

    public function QueryMessageHandler(target:IEventDispatcher=null) {
        super(target);
        _handlerMethods[RowDescription] = handleMetadata;
        _handlerMethods[DataRow] = handleData;
        _handlerMethods[EmptyQueryResponse] = handleEmpty;
        _handlerMethods[CommandComplete] = handleComplete;
    }

    public override function getCallback(msg:IBEMessage):Function {
    	return _stmt ? super.getCallback(msg) : null;
    }

    public function set currentStatement(stmt:IStatement):void {
    	// This will need to be reset to null when the connection is rfq
    	// and this query has completed--we cannot simply do this in
    	// handleComplete, since with the simple query protocol, multiple
    	// commands can result from a single statement
    	_stmt = stmt;
    }

    private function handleMetadata(msg:RowDescription):void {
        
    }

    private function handleData(msg:DataRow):void {
        
    }

    private function handleComplete(msg:CommandComplete):void {
        
    }

    private function handleEmpty(msg:EmptyQueryResponse):void {
        // this is equivalent to CommandComplete when an empty
        // query string is sent; for now, do nothing
    }
    
}

import org.postgresql.febe.event.NotificationEvent;
import org.postgresql.febe.message.NotificationResponse;
import org.postgresql.febe.ProtocolError;
import flash.events.Event;
import org.postgresql.febe.TransactionStatus;

class NotificationHandler extends AbstractFEBEMessageHandler {

    public function NotificationHandler(target:IEventDispatcher) {
        super(target);
        _handlerMethods[NotificationResponse] = handleNotification;
    }

    private function handleNotification(msg:NotificationResponse):void {
        dispatchEvent(new NotificationEvent(msg.condition, msg.notifierPid));
    }
}