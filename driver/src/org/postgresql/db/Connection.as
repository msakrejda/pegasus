package org.postgresql.db {

    import org.postgresql.febe.ArgumentInfo;
    import org.postgresql.febe.IExtendedQueryHandler;
    import flash.events.EventDispatcher;

    import org.postgresql.CodecError;
    import org.postgresql.ProtocolError;
    import org.postgresql.event.ConnectionErrorEvent;
    import org.postgresql.event.ConnectionEvent;
    import org.postgresql.event.NoticeEvent;
    import org.postgresql.event.NotificationEvent;
    import org.postgresql.event.ParameterChangeEvent;
    import org.postgresql.febe.FEBEConnection;
    import org.postgresql.febe.IConnectionHandler;
    import org.postgresql.febe.IQueryHandler;
    import org.postgresql.log.ILogger;
    import org.postgresql.log.Log;

    public class Connection extends EventDispatcher implements IConnection, IConnectionHandler {

        private static const LOGGER:ILogger = Log.getLogger(Connection);

        private var _baseConn:FEBEConnection;
        private var _queryHandlerFactory:QueryHandlerFactory;

        private var _pendingExecution:Array;
        private var _currentHandler:IQueryHandler;
        private var _currentToken:QueryToken;

        public function Connection(baseConn:FEBEConnection, queryHandlerFactory:QueryHandlerFactory) {
            _baseConn = baseConn;
            _queryHandlerFactory = queryHandlerFactory;

            // TODO: copy, function call

            _pendingExecution = [];
            _baseConn.connect(this);
        }

        public function handleConnected():void {
            dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTED));
        }

        public function handleStreamError(error:Error):void {
            LOGGER.error("Stream error: " + error.message);
            dispatchEvent(new ConnectionErrorEvent(ConnectionErrorEvent.CONNECTIVITY_ERROR, error));
        }

        public function handleProtocolError(error:ProtocolError):void {
            LOGGER.error("Protocol error: " + error.message);
            dispatchEvent(new ConnectionErrorEvent(ConnectionErrorEvent.PROTOCOL_ERROR, error));
        }

        public function handleCodecError(error:CodecError):void {
            LOGGER.warn("Codec error: " + error.message);
            dispatchEvent(new ConnectionErrorEvent(ConnectionErrorEvent.CODEC_ERROR, error));
        }

        public function handleSQLError(fields:Object):void {
            LOGGER.warn("Error:");
            for (var key:String in fields) {
                LOGGER.warn("\t{0}: {1}", key, fields[key]);
            }
            dispatchEvent(new NoticeEvent(NoticeEvent.ERROR, fields));
        }

        public function handleNotice(fields:Object):void {
            LOGGER.info("Notice:");
            for (var key:String in fields) {
                LOGGER.info("\t{0}: {1}", key, fields[key]);
            }
            dispatchEvent(new NoticeEvent(NoticeEvent.NOTICE, fields));
        }

        public function handleNotification(condition:String, notifierPid:int):void {
            dispatchEvent(new NotificationEvent(condition, notifierPid));
        }

        public function handleParameterChange(name:String, newValue:String):void {
            dispatchEvent(new ParameterChangeEvent(name, newValue));
        }

        public function handleReady(status:String):void {
            if (_pendingExecution.length > 0) {
                var nextQuery:PendingQueryExecution = _pendingExecution.shift();
                executeNext(nextQuery.handler, nextQuery.token, nextQuery.sql, nextQuery.args);
            }
        }

        private function executeNext(handler:IResultHandler, token:QueryToken, sql:String, args:Array):void {
            _currentToken = token;
            if (args) {
                doParameterizedExecute(handler, sql, args);
            } else {
                doExecute(handler, sql);
            }
        }

        public function cancel(token:QueryToken):Boolean {
            var found:Boolean = false;
            if (_currentToken == token) {
                _baseConn.cancel();
                found = true;
            } else {
                // See if a pending query corresponds to this token
                for (var i:int = 0; i < _pendingExecution.length; i++) {
                    var pending:PendingQueryExecution = _pendingExecution[i];
                    if (pending.token == token) {
                        _pendingExecution.splice(i, 1);
                        found = true;
                        break;
                    }
                }
            }
            return found;
        }

        private function doExecute(handler:IResultHandler, sql:String):void {
            var queryHandler:IQueryHandler = _queryHandlerFactory.createSimpleHandler(handler);
            _currentHandler = queryHandler;
            _baseConn.executeSimpleQuery(sql, queryHandler);
        }

        private function doParameterizedExecute(handler:IResultHandler, sql:String, argValues:Array):void {
            var queryHandler:IExtendedQueryHandler = _queryHandlerFactory.createExtendedHandler(handler);
            // the queryHandler can give us parameter info, encoded parameter values, and desired input types
            var arguments:Array = queryHandler.describeArguments(argValues, _baseConn.serverParams);
            var argOids:Array = arguments.map(function(arg:ArgumentInfo, index:int, array:Array):int {
                return arg.typeOid;
            });
            _baseConn.prepareStatement('', sql, argOids, queryHandler);
            // We don't know what these will be without a describe. But we'd need to wait for a statement-flavor
            // describe to return before we could specify per-column result formats, since we don't know how
            // many columns there will be. To get around this, we could force a format here, but the backend
            // will send us RowDescription messages specifying an unknown format (which is unfortunately aliased
            // to the same value as TEXT format), so we'd need to set the query handler straight.
            var resultFormats:Array = queryHandler.getOutputFormats(null);
            _baseConn.bindStatement('', '', arguments, resultFormats);
            _baseConn.describePortal('');
            _baseConn.execute('');
            _baseConn.sync();
        }

        public function close():void {
            _baseConn.close();
        }

        public function execute(handler:IResultHandler, sql:String, args:Array=null):QueryToken {
            var token:QueryToken = new QueryToken(sql);
            if (_baseConn.rfq) {
                executeNext(handler, token, sql, args);
            } else {
                _pendingExecution.push(new PendingQueryExecution(token, handler, sql, args));
            }
            return token;
        }
    }
}
import org.postgresql.db.IResultHandler;
import org.postgresql.db.QueryToken;

class PendingQueryExecution {
    public var token:QueryToken;
    public var handler:IResultHandler;
    public var sql:String;
    public var args:Array;

    public function PendingQueryExecution(token:QueryToken, handler:IResultHandler, sql:String, args:Array=null) {
        this.token = token;
        this.handler = handler;
        this.sql = sql;
        this.args = args;
    }

}