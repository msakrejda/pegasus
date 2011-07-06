Pegasus
^^^^^^^

An ActionScript 3 driver for the PostgreSQL open source database.


Overview
~~~~~~~~

Pegasus currently supports both the simple and extended query
protocols, clear-text, md5 hashed, and trust authentication, and the
PostgreSQL notification mechanism (LISTEN/NOTIFY). It has an
extensible data type handling system with built-in support for the
most common types (Date, Number, int, Boolean, and String in
ActionScript, and their PostgreSQL equivalents).

The pegasus core library can be used in plain Flash stand-alone
applications, Flash web applications, and Flex or AIR applications
(albeit the Flash cross-domain policies will prevent you from doing
anything too colorful from a web app).

The pegasus repository includes pgconsole, a simple AIR application
which can connect to a PostgreSQL server, issue queries, and display
results. It also supports notifications (i.e., you can issue a LISTEN
and get notifications of the corresponding NOTIFY events).


Example
~~~~~~~

Here is an example of pegasus usage:: 

    // Create a ConnectionFactory
    var connFactory:ConnectionFactory = new ConnectionFactory();

    // Pegasus uses jdbc-like URLs for configuring host, port, and target database
    // as well as for connection properties (not shown)
    var url:String = 'asdbc:postgresql://localhost:5432/postgres';
    var user:String = 'postgres';
    var password:String = 'postgres';
    var conn:IConnection = connFactory.createConnection(url, user, password);

    // Add event listeners. The actual functions are omitted; they are fairly
    // straightforward event handlers. Note that the NoticEvent.ERROR handler
    // is the mechanism for communicating query errors, so be sure to listen
    // for at least these events
    conn.addEventListener(NoticeEvent.NOTICE, handleNotice);
    conn.addEventListener(NoticeEvent.ERROR, handleError);
    conn.addEventListener(ParameterChangeEvent.PARAMETER_CHANGE, handleParamChange);
    conn.addEventListener(NotificationEvent.NOTIFICATION, handleNotification);
    conn.addEventListener(ConnectionEvent.CONNECTED, handleConnected);
    conn.addEventListener(ConnectionErrorEvent.CONNECTIVITY_ERROR, handleConnectivityError);
    conn.addEventListener(ConnectionErrorEvent.PROTOCOL_ERROR, handleProtocolError);
    conn.addEventListener(ConnectionErrorEvent.CODEC_ERROR, handleCodecError);

    // Each query needs a result handler. Pegasus comes with two types of result handlers,
    // or you can write your own. A result handler needs to respond to results from
    // the query (if any) and to successful query completion. The EventResultHandler dispatches
    // events when results are available and when the query completes.
    var handler:IResultHandler = new EventResultHandler();
    // Add a handler for query results; you can often ignore completion
    IEventDispatcher(handler).addEventListener(QueryResultEvent.RESULT, handleResult);
    // Parameter markers use standard PostgreSQL syntax
    conn.execute(handler, "select 'hello ' || $1", [ 'world' ]);

This is a sample result handler::

    function handleResult(event:QueryResultEvent):void {
    	trace("Columns are:");
        for (var col:IColumn in event.columns) {
	    trace('Column', col.name, col.type);
	}
	trace("Data is:");
	for (var row:Object in event.data) {
	    for (var col:IColumn in event.columns) {
	    	trace("Value for column", col.name, "is", row[col.name]);
	    }
	}
    }

A more extensive example is available in `pgconsole`.
