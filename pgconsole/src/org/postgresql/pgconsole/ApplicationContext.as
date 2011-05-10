package org.postgresql.pgconsole {

    import org.postgresql.pgconsole.controller.AddNotificationCommand;
    import org.postgresql.pgconsole.signal.NotificationSignal;
    import org.postgresql.pgconsole.controller.AddNoticeCommand;
    import org.postgresql.pgconsole.controller.SelectResultsCommand;
    import org.postgresql.pgconsole.signal.SelectResultsSignal;
    import org.postgresql.pgconsole.controller.AddQueryCommand;
    import org.postgresql.pgconsole.model.activity.ConnectionActivityModel;
    import org.postgresql.pgconsole.controller.AddQueryCompletionCommand;
    import org.postgresql.pgconsole.signal.ResultsSelectedSignal;
    import org.postgresql.pgconsole.view.model.QueryResultViewPresentationModel;
    import org.postgresql.log.LogLevel;
    import org.postgresql.log.TraceTarget;
    import org.postgresql.log.Log;
    import org.postgresql.db.ConnectionFactory;
    import org.postgresql.pgconsole.signal.ErrorSignal;
    import org.postgresql.pgconsole.signal.NoticeSignal;
    import org.postgresql.pgconsole.signal.QueryCompletionSignal;
    import org.postgresql.pgconsole.service.QueryService;
    import org.postgresql.pgconsole.controller.ExecuteCommand;
    import org.postgresql.pgconsole.signal.QuerySignal;
    import org.postgresql.pgconsole.signal.ConnectionActivityChangedSignal;
    import org.postgresql.pgconsole.view.model.ConnectionActivityViewPresentationModel;
    import org.postgresql.pgconsole.view.model.QueryInputViewPresentationModel;
    import org.postgresql.pgconsole.controller.ConnectCommand;
    import org.postgresql.pgconsole.signal.ConnectSignal;
    import org.postgresql.pgconsole.signal.DisconnectedSignal;
    import org.postgresql.pgconsole.signal.ConnectedSignal;
    import org.postgresql.pgconsole.view.model.MainViewPresentationModel;
    import org.robotlegs.mvcs.SignalContext;
    import flash.display.DisplayObjectContainer;

    public class ApplicationContext extends SignalContext {
        public function ApplicationContext(contextView:DisplayObjectContainer = null, autoStartup:Boolean = true) {
            super(contextView, autoStartup);
        }

        override public function startup():void {
            super.startup();

            Log.addTarget(new TraceTarget(), LogLevel.DEBUG);

            // Miscellaneous dependencies
            injector.mapSingleton(ConnectionFactory);

            // Views
            viewMap.mapPackage("org.postgresql.pgconsole.view");

            // Services
            injector.mapSingleton(QueryService);

            // Application model
            injector.mapSingleton(ConnectionActivityModel);

            // "Request" signals and their corresponding Commands
            signalCommandMap.mapSignalClass(ConnectSignal, ConnectCommand);
            signalCommandMap.mapSignalClass(QuerySignal, ExecuteCommand);
            signalCommandMap.mapSignalClass(QuerySignal, AddQueryCommand);
            signalCommandMap.mapSignalClass(QueryCompletionSignal, AddQueryCompletionCommand);
            signalCommandMap.mapSignalClass(SelectResultsSignal, SelectResultsCommand);
            signalCommandMap.mapSignalClass(NoticeSignal, AddNoticeCommand);
            signalCommandMap.mapSignalClass(NotificationSignal, AddNotificationCommand);

            // "Response" Signals
            injector.mapSingleton(ConnectedSignal);
            injector.mapSingleton(DisconnectedSignal);
            injector.mapSingleton(ConnectionActivityChangedSignal);
            injector.mapSingleton(ErrorSignal);
            injector.mapSingleton(ResultsSelectedSignal);

            // Presentation models
            injector.mapSingleton(MainViewPresentationModel);
            injector.mapSingleton(QueryInputViewPresentationModel);
            injector.mapSingleton(QueryResultViewPresentationModel);
            injector.mapSingleton(ConnectionActivityViewPresentationModel);
        }
    }
}
