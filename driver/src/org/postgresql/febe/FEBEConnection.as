package org.postgresql.febe {

import flash.utils.ByteArray;
import com.adobe.crypto.MD5;
import org.postgresql.febe.message.Flush;
import org.postgresql.febe.message.Sync;
import org.postgresql.febe.message.Execute;
import org.postgresql.febe.message.Bind;
import org.postgresql.febe.message.Describe;
import org.postgresql.febe.message.Close;
import org.postgresql.febe.message.Parse;
import flash.events.Event;

import org.postgresql.CodecError;
import org.postgresql.InvalidStateError;
import org.postgresql.ProtocolError;
import org.postgresql.UnsupportedProtocolFeatureError;
import org.postgresql.febe.message.AuthenticationRequest;
import org.postgresql.febe.message.BackendKeyData;
import org.postgresql.febe.message.CancelRequest;
import org.postgresql.febe.message.CommandComplete;
import org.postgresql.febe.message.DataRow;
import org.postgresql.febe.message.EmptyQueryResponse;
import org.postgresql.febe.message.ErrorResponse;
import org.postgresql.febe.message.IBEMessage;
import org.postgresql.febe.message.IFEMessage;
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
import org.postgresql.util.assert;

/**
 * A bare-bones abstraction over the PostgreSQL Front End / Back End (FEBE) protocol.
 * This effectively provides a programmatic, message-level interface to the protocol
 * defined in <code>http://developer.postgresql.org/pgdocs/postgres/protocol-flow.html</code>.
 * This can then serve as a building block for more user-friendly connection / query /
 * result abstractions.
 * <br/>
 * At the moment, the <code>FEBEConnection</code> only supports a single outstanding
 * query at a time. If another query is submitted before the connection is ready, a
 * <code>ProtocolError</code> is raised. This limitation is likely to be removed in the
 * future.
 *
 * @see org.postgresql.ProtocolError
 */
public class FEBEConnection {

   private static const LOGGER:ILogger = Log.getLogger(FEBEConnection);

   private var _params:Object;

   private var _streamFactory:MessageStreamFactory;
   private var _stream:IMessageStream;
   private var _messageHandler:MessageHandler;

   private var _authenticated:Boolean;
   private var _connecting:Boolean;
   private var _connected:Boolean;

   private var _rfq:Boolean;
   private var _status:String;

   private var _currentQueryHandler:IQueryHandler;
   private var _statementHandlerMap:Object;

   private var _currResults:Array;
   private var _hasCodecError:Boolean;

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

   public function FEBEConnection(params:Object, password:String, streamFactory:MessageStreamFactory) {
      _params = params;
      _streamFactory = streamFactory;

      _connected = false;
      _connecting = true;
      _authenticated = false;

      _currentQueryHandler = null;
      _statementHandlerMap = {};

      _hasCodecError = false;
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
      if (_connected) {
         onProtocolError(new ProtocolError("Already connected"));
      }
      _connHandler = handler;
      _connecting = true;

      _stream = _streamFactory.create();
      _messageHandler = new MessageHandler(_stream);
      // TODO: This is a little ugly, especially since the underlying
      // data stream can theoretically give up the ghost before this
      // step happens. In practice, that's not likely due to Flash
      // Player's asynchronous execution model, but it'd be nice to fix.
      _stream.addEventListener(MessageStreamErrorEvent.ERROR, handleStreamError);
      _stream.addEventListener(MessageStreamEvent.BATCH_COMPLETE, handleBatchComplete);

      _messageHandler.setMessageListener(AuthenticationRequest, handleAuth);
      _messageHandler.setMessageListener(BackendKeyData, handleKeyData);
      _messageHandler.setMessageListener(ParameterStatus, handleParam);
      _messageHandler.setMessageListener(NoticeResponse, handleNotice);
      _messageHandler.setMessageListener(ErrorResponse, handleError);
      _messageHandler.setMessageListener(ReadyForQuery, handleFirstRfq);

      send(new StartupMessage(_params));
   }

   private function send(msg:IFEMessage):void {
      if (_connected || (_connecting && (msg is StartupMessage || msg is PasswordMessage))) {
         try {
            _stream.send(msg);
         } catch (e:Error) {
            _connHandler.handleStreamError(e);
         }
      } else {
         _connHandler.handleStreamError(new InvalidStateError("Connection closed"));
      }
   }

   private function handleUnexpectedMessage(msg:IBEMessage):void {
      onProtocolError(new ProtocolError("Unexpected message: " + msg.type));
   }

   private function handleAuth(msg:AuthenticationRequest):void {
      // TODO: more auth types
      if (msg.subtype == AuthenticationRequest.OK) {
         _authenticated = true;
      } else if (msg.subtype == AuthenticationRequest.CLEARTEXT_PASSWORD) {
         send(new PasswordMessage(_password));
      } else if (msg.subtype == AuthenticationRequest.MD5_PASSWORD) {
         if (msg.auxdata.bytesAvailable != 4) {
            onProtocolError(new ProtocolError("Expected four bytes of salt data for md5 password authentication, got " +
                  msg.auxdata.bytesAvailable));
         }

         var step1:ByteArray = new ByteArray();
         step1.writeUTFBytes(_password);
         // TODO: it's a little ugly to reference user here
         step1.writeUTFBytes(_params.user);
         step1.position = 0;

         var step1digest:String = MD5.hashBinary(step1);

         var step2:ByteArray = new ByteArray();
         step2.writeUTFBytes(step1digest);
         // the auxdata contains the salt
         step2.writeBytes(msg.auxdata, 0, 4);
         step2.position = 0;

         var finalDigest:String = MD5.hashBinary(step2);

         send(new PasswordMessage("md5" + finalDigest));
      } else {
         onProtocolError(new UnsupportedProtocolFeatureError(
               "Unsupported authentication type requested: " + msg.subtype));
      }
   }

   private function handleFirstRfq(msg:ReadyForQuery):void {
      if (_authenticated) {
         _connecting = false;
         _connected = true;

         _messageHandler.setMessageListener(ReadyForQuery, handleRfq);
         _messageHandler.setMessageListener(AuthenticationRequest, handleUnexpectedMessage);
         _messageHandler.setMessageListener(BackendKeyData, handleUnexpectedMessage);

         _messageHandler.setMessageListener(NotificationResponse, handleNotification);
         _messageHandler.setMessageListener(RowDescription, handleMetadata);
         _messageHandler.setMessageListener(DataRow, handleData);

         // TODO: We should probably add handlers to process parseComplete / bindComplete / portalSuspended.
         // We can ignore them for now, since we don't do anything with them, but it's a little ugly to
         // drop them implicitly...

         _messageHandler.setMessageListener(CommandComplete, handleComplete);
         _messageHandler.setMessageListener(EmptyQueryResponse, handleEmpty);

         _connHandler.handleConnected();
         handleRfq(msg);
      } else {
         onProtocolError(new ProtocolError("Unexpected ReadyForQuery without AuthenticationOK"));
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
      if (_currentQueryHandler) {
         _currentQueryHandler.dispose();
         _currentQueryHandler = null;
      }
      _connHandler.handleReady(_status);
   }

   private function handleNotification(msg:NotificationResponse):void {
      _connHandler.handleNotification(msg.condition, msg.notifierPid);
   }

   private function handleNotice(msg:ResponseMessageBase):void {
      _connHandler.handleNotice(msg.fields);
   }

   private function handleError(msg:ErrorResponse):void {
      _connHandler.handleSQLError(msg.fields);
   }

   private function handleMetadata(msg:RowDescription):void {
      if (_currentQueryHandler) {
         assert("Unexpected data remaining in result buffer", _currResults.length == 0);
         try {
            _currentQueryHandler.handleMetadata(msg.fields);
         } catch (e:CodecError) {
            onCodecError(e);
         }
      } else if (_hasCodecError) {
         /* do nothing; just drop */
      } else {
         onProtocolError(new ProtocolError('Unexpected RowDescription message'));
      }
   }

   private function handleData(msg:DataRow):void {
      if (_currentQueryHandler) {
         _currResults.push(msg.rowBytes);
      } else if (_hasCodecError) {
         /* do nothing; just drop */
      } else {
         onProtocolError(new ProtocolError('Unexpected DataRow message'));
      }
   }

   private function handleComplete(msg:CommandComplete):void {
      if (_currentQueryHandler) {
         flushPendingResults();
         _currentQueryHandler.handleCompletion(msg.command, msg.affectedRows, msg.oid, null);
      } else if (_hasCodecError) {
         _hasCodecError = false;
      } else {
         onProtocolError(new ProtocolError("Unexpected CommandComplete"));
      }
   }

   private function handleEmpty(msg:EmptyQueryResponse):void {
      // This is equivalent to CommandComplete when an empty query completes.
      // Let's call this a query completing successfully. Theoretically, we may want
      // to handle this differently, but there's little practical use for that.
      if (_currentQueryHandler) {
         _currentQueryHandler.handleCompletion('EMPTY QUERY');
      } else {
         onProtocolError(new ProtocolError("Unexpected EmptyQueryResponse"));
      }
   }

   private function flushPendingResults():void {
      if (_currentQueryHandler && _currResults.length > 0) {
         try {
            // Technically, passing the serverParams like this may not be quite right.
            // Theoretically, we may get some data, get notification of server parameter
            // changes, and get more data. In batching it like this, we may give the false
            // impression that a consistent set of server params was used for all the
            // returned rows. This is so preposterously unlikely (and may even be impossible
            // if the server is processing messages in a sensible manner) that we will
            // ignore it for now.
            _currentQueryHandler.handleData(_currResults, serverParams);
         } catch (e:CodecError) {
            onCodecError(e);
         }
         _currResults = [];
      }
   }

   private function handleBatchComplete(e:Event):void {
      flushPendingResults();
   }

   public function executeSimpleQuery(sql:String, handler:IQueryHandler):void {
      ensureConnected();
      ensureReady();
      _rfq = false;
      _currentQueryHandler = handler;
      send(new Query(sql));
   }

   /*public function executeQuery(sql:String, params:Array, handler:IQueryHandler):void {
       ensureConnected();
       ensureReady();
       _rfq = false;
       // > parse(statement)
       // < parseComplete | errorResponse
       // > bind(statement, portal, params)
       // < bindComplete | errorResponse
       // > describe(portal)
       // < rowDescription
       // > execute(portal, limit)
       // < commandComplete | errorResponse | emptyQueryResponse | portalSuspended
       // > sync
   }*/

   public function prepareStatement(name:String, sql:String, paramOids:Array, handler:IExtendedQueryHandler):void {
      ensureConnected();
      ensureReady();
      _rfq = false;
      _statementHandlerMap[name] = handler;
      _currentQueryHandler = handler;
      send(new Parse(name, sql, paramOids));
   }

   public function describeStatement(name:String):void {
      ensureConnected();
      ensureProcessingPrepared();
      send(new Describe(name, Describe.STATEMENT));
   }

   public function bindStatement(portal:String, statement:String, arguments:Array, resultFormats:Array):void {
      ensureConnected();
      ensureProcessingPrepared();
      var formats:Array = [];
      var values:Array = [];
      for each (var argument:ArgumentInfo in arguments) {
         formats.push(argument.format);
         values.push(argument.value);
      }
      send(new Bind(portal, statement, formats, values, resultFormats));
   }

   public function describePortal(name:String):void {
      ensureConnected();
      ensureProcessingPrepared();
      send(new Describe(name, Describe.PORTAL));
   }

   public function closePortal(name:String):void {
      ensureConnected();
      ensureProcessingPrepared();
      send(new Close(Close.PORTAL, name));
   }

   public function closeStatement(name:String):void {
      ensureConnected();
      ensureProcessingPrepared();
      delete _statementHandlerMap[name];
      send(new Close(Close.STATEMENT, name));
   }

   public function execute(portal:String, rowCount:int=0):void {
      ensureConnected();
      ensureProcessingPrepared();
      send(new Execute(portal, rowCount));
   }

   public function sync():void {
      ensureConnected();
      ensureProcessingPrepared();
      send(new Sync());
   }

   public function flush():void {
      ensureConnected();
      ensureProcessingPrepared();
      send(new Flush());
   }

   // additionally, there is fastpath (function call) and copy. It might be handy to
   // support a structured explain

   public function cancel():void {
      ensureConnected();
      // Note that cancel needs to happen in a separate connection to make any sense.
      // Since the broker goes out of scope here as soon as the method body ends,
      // there may be some issues with GC (since socket communication is asynchronous),
      // but Flash Player *should* queue everything it needs to do the physical send
      // before GC. To do this right, we'd probably have to keep a reference to this
      // broker and listen for close (or error) and only remove the reference then
      try {
         var cancelStream:IMessageStream = _streamFactory.create();
         cancelStream.send(new CancelRequest(_backendPid, _backendKey));
         try {
            cancelStream.close();
         } catch (e:Error) {
            LOGGER.warn("Could not close cancel broker: " + e.message);
         }
      } catch (e:Error) {
         LOGGER.warn("Could not cancel statement: " + e.message);
      }
   }

   private function handleStreamError(e:MessageStreamErrorEvent):void {
      close();
      _connHandler.handleStreamError(new Error("Error event: " + e.text));
   }

   public function close():void {
      if (_connected) {
         if (_stream.connected) {
            try {
               _stream.send(new Terminate());
               _stream.close();
            } catch (e:Error) {
               LOGGER.warn("Could not shut down cleanly: " + e.message);
            }
         }
         _connected = false;
      }
   }

   private function onProtocolError(error:ProtocolError):void {
      // We don't know what the heck is going on. Bail.
      close();
      _connHandler.handleProtocolError(error);
   }

   private function onCodecError(error:CodecError):void {
      // The query dies, but the connection is fine. We clean up
      // the query handler on ReadyForQuery
      _connHandler.handleCodecError(error);
      // Note that we still may need to throw away any number of DataRow messages
      _hasCodecError = true;
   }

   private function ensureConnected():void {
      if (!_connected) {
         _connHandler.handleStreamError(new Error("Not connected"));
      }
   }

   private function ensureReady():void {
      if (!_rfq) {
         onProtocolError(new ProtocolError("FEBEConnection is not ready for query"));
      }
   }

   private function ensureProcessingPrepared():void {
      if (!(_currentQueryHandler is IExtendedQueryHandler)) {
         onProtocolError(new ProtocolError("FEBEConnection is not processing a prepared statement"));
      }
   }

}
}

import flash.utils.Dictionary;
import org.postgresql.febe.IMessageStream;
import org.postgresql.febe.MessageEvent;
import org.postgresql.febe.message.IBEMessage;
import org.postgresql.util.assert;
import org.postgresql.log.ILogger;
import org.postgresql.log.Log;

/**
 * Helper class for reading messages. Note that this is not a full wrapper
 * around the broker; it's just a simple facility of installing and removing
 * message listeners.
 */
class MessageHandler {

   private static const LOGGER:ILogger = Log.getLogger(MessageHandler);

   private var _msgListeners:Dictionary;
   private var _stream:IMessageStream;

   public function MessageHandler(stream:IMessageStream) {
      _msgListeners = new Dictionary();
      _stream = stream;
      _stream.addEventListener(MessageEvent.RECEIVED, handleMessageReceived);
   }

   private function handleMessageReceived(e:MessageEvent):void {
      var msg:IBEMessage = IBEMessage(e.message);
      assert("No message associated with message event", msg);
      if (Object(msg).constructor in _msgListeners) {
         var listener:Function = _msgListeners[Object(msg).constructor];
         listener(msg);
      } else {
         LOGGER.warn("No message listener associated with message {0}; dropping", msg);
      }
   }

   public function setMessageListener(msg:Class, callback:Function):void {
      _msgListeners[msg] = callback;
   }

   public function clearMessageListener(msg:Class):void {
      delete _msgListeners[msg];
   }
}
