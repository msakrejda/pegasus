package org.postgresql.pgconsole.controller {
    import org.postgresql.pgconsole.service.QueryService;
    import org.robotlegs.mvcs.SignalCommand;

    public class DisconnectCommand extends SignalCommand {

        [Inject]
        public var queryService:QueryService;

        override public function execute():void {
            queryService.disconnect();
        }
    }
}
