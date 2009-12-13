package org.postgresql.febe {

	import flash.events.EventDispatcher;
	
	import mx.logging.ILogger;
	import mx.logging.Log;
	
	import org.postgresql.db.ConnectionEvent;
	import org.postgresql.febe.message.IBEMessage;
	import org.postgresql.febe.message.ParameterStatus;
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

        public var rfq:Boolean;
        public var transactionStatus:String;

        private var _connected:Boolean;
        private var _handlers:Array;

		public function FEBEConnection(params:Object, broker:MessageBroker) {
			_params = params;
			_broker = broker;

            _connected = false;
            _handlers = [];

            // TODO: update these from rfq and commandComplete 
            rfq = false;
            transactionStatus = 'invalid';
            // add a Message listener to the broker and feed the various handlers
            // off the message stream
		}

        public function connect():void {
            _broker.send(new StartupMessage(_params));
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
        // query-data-available and statement-complete messages.
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

        private function handleReadyForQuery(e:MessageEvent):void {
            transactionStatus = ReadyForQuery(e.message).status;
            rfq = true;
            if (!_connected) {
                _connected = true;
                dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTED));
            }
        }

        public function close():void {
            if (_connected) {
                _broker.send(new Terminate());                
            }
        }

        public function addHandler(handler:IFEBEMessageHandler):void {
        	_handlers.push(handler);
        }

        public function removeHandler(handler:IFEBEMessageHandler):void {
            _handlers = _handlers.filter(function(item:IFEBEMessageHandler):Boolean {
            	return item != handler;
            });
        }

        private function processHandlers(msg:IBEMessage):void {
            for each (var h:IFEBEMessageHandler in _handlers) {
                var callback:Function = h.getCallback(msg);
                if (callback != null) {
                	callback(msg);
                	// TODO: break here once the message is handled? this is really
                	// only interesting for ERROR and NOTICE messages, since these
                	// may occurr in the context of executing a statement ('select some invalid sql')
                	// or a connection (invalid username).
                }
            }
            // TODO: warn about unprocessed messages?
        }

	}
}