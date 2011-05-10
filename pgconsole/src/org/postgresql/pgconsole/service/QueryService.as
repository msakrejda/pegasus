package org.postgresql.pgconsole.service {
    import org.postgresql.pgconsole.signal.NotificationSignal;
    import org.postgresql.pgconsole.model.vo.NotificationVO;
    import org.postgresql.pgconsole.model.vo.NoticeVO;
    import org.postgresql.pgconsole.signal.NoticeSignal;
    import org.postgresql.NoticeFields;
    import org.postgresql.pgconsole.signal.DisconnectedSignal;
    import org.postgresql.pgconsole.signal.ConnectedSignal;
    import org.postgresql.pgconsole.signal.QueryCompletionSignal;
    import org.postgresql.pgconsole.model.vo.QueryVO;
    import org.postgresql.CodecError;
    import org.postgresql.pgconsole.signal.ErrorSignal;
    import org.postgresql.event.ConnectionEvent;
    import org.postgresql.event.ConnectionErrorEvent;
    import org.postgresql.event.NotificationEvent;
    import org.postgresql.event.ParameterChangeEvent;
    import org.postgresql.event.NoticeEvent;
    import org.postgresql.db.ConnectionFactory;
    import org.postgresql.db.IConnection;

    public class QueryService {

        private var _conn:IConnection;

        [Inject]
        public var connFactory:ConnectionFactory;

        [Inject]
        public var connectedSignal:ConnectedSignal;
        [Inject]
        public var disconnectedSignal:DisconnectedSignal;
        [Inject]
        public var errorSignal:ErrorSignal;
        [Inject]
        public var queryCompletionSignal:QueryCompletionSignal;
        [Inject]
        public var noticeSignal:NoticeSignal;
        [Inject]
        public var notificationSignal:NotificationSignal;

        public function connect(url:String, user:String, password:String):void {
            disconnect();
            _conn = connFactory.createConnection(url, user, password);
            _conn.addEventListener(NoticeEvent.NOTICE, handleNotice);
            _conn.addEventListener(NoticeEvent.ERROR, handleError);
            _conn.addEventListener(ParameterChangeEvent.PARAMETER_CHANGE, handleParamChange);
            _conn.addEventListener(NotificationEvent.NOTIFICATION, handleNotification);
            _conn.addEventListener(ConnectionEvent.CONNECTED, handleConnected);
            _conn.addEventListener(ConnectionErrorEvent.CONNECTIVITY_ERROR, handleConnectivityError);
            _conn.addEventListener(ConnectionErrorEvent.PROTOCOL_ERROR, handleProtocolError);
            _conn.addEventListener(ConnectionErrorEvent.CODEC_ERROR, handleCodecError);
        }

        private function handleCodecError(event:ConnectionErrorEvent):void {
            var error:CodecError = event.cause as CodecError;
            var msg:String;
            if (error) {
                msg = error.direction + "error: could not map " + error.as3Type + " to oid " + error.oid + ".\n"
                    + error.cause.message;
            } else {
                msg = "An unknown encoding/decoding error has occurred";
            }
            errorSignal.dispatch(msg);
        }

        private function handleProtocolError(event:ConnectionErrorEvent):void {
            disconnectedSignal.dispatch();
        }

        private function handleConnectivityError(event:ConnectionErrorEvent):void {
            disconnectedSignal.dispatch();
        }

        private function handleConnected(event:ConnectionEvent):void {
            connectedSignal.dispatch();
        }

        private function handleNotification(event:NotificationEvent):void {
            notificationSignal.dispatch(new NotificationVO(event.condition, event.notifierPid));
        }

        private function handleParamChange(event:ParameterChangeEvent):void {
            // ignore
        }

        private function key(obj:Object):String {
            var result:Array = [];
            for (var prop:String in obj) {
                   result.push(prop + ':' + obj[prop]);
            }
            return '{' +  result.join(',') + '}';
        }


        private function handleError(event:NoticeEvent):void {
            trace('received error:',key(event.fields));
            noticeSignal.dispatch(new NoticeVO(event.fields));
        }

        private function handleNotice(event:NoticeEvent):void {
            trace('received notice:',key(event.fields));
            noticeSignal.dispatch(new NoticeVO(event.fields));
        }

        public function disconnect():void {
            if (_conn) {
                _conn.close();
                _conn.removeEventListener(NoticeEvent.NOTICE, handleNotice);
                _conn.removeEventListener(NoticeEvent.ERROR, handleError);
                _conn.removeEventListener(ParameterChangeEvent.PARAMETER_CHANGE, handleParamChange);
                _conn.removeEventListener(NotificationEvent.NOTIFICATION, handleNotification);
                _conn.removeEventListener(ConnectionEvent.CONNECTED, handleConnected);
                _conn.removeEventListener(ConnectionErrorEvent.CONNECTIVITY_ERROR, handleConnectivityError);
                _conn.removeEventListener(ConnectionErrorEvent.PROTOCOL_ERROR, handleProtocolError);
                _conn.removeEventListener(ConnectionErrorEvent.CODEC_ERROR, handleCodecError);
                _conn = null;
            }
        }

        public function execute(query:QueryVO):void {
            if (_conn) {
                var handler:PGConsoleHandler = new PGConsoleHandler(query, queryCompletionSignal);
                trace('executing',query.sql,'with',query.args? query.args.join(',') : '');
                _conn.execute(handler, query.sql, query.args);
            } else {
                errorSignal.dispatch("Cannot execute query: not connected");
            }
        }
    }
}
import org.postgresql.db.IColumn;
import org.postgresql.pgconsole.signal.SelectResultsSignal;
import org.postgresql.pgconsole.model.vo.QueryCompletionVO;
import org.postgresql.pgconsole.signal.QueryCompletionSignal;
import org.postgresql.pgconsole.model.vo.QueryVO;
import org.postgresql.db.ResultHandlerBase;

class PGConsoleHandler extends ResultHandlerBase {

    private var _completionSignal:QueryCompletionSignal;

    public function PGConsoleHandler(query:QueryVO, completionSignal:QueryCompletionSignal) {
        _completionSignal = completionSignal;
    }

    override public function doHandleCompletion(command:String, rows:int, oid:int):void {
        var completion:QueryCompletionVO;
        if (data && columns) {
            trace('Got data:');
            for each (var row:Object in data) {
                var rowStr:Array = [];
                for each (var field:IColumn in columns) {
                    rowStr.push(row[field.name]);
                }
                trace(rowStr.join(','));
            }
            completion = new QueryCompletionVO(command, rows, columns, data);
        } else {
            completion = new QueryCompletionVO(command, rows);
        }
        _completionSignal.dispatch(completion);
    }
}