package org.postgresql.pgconsole.controller {
    import org.postgresql.pgconsole.service.QueryService;
    import org.postgresql.pgconsole.model.vo.ConnectionAttemptVO;
    import org.robotlegs.mvcs.SignalCommand;

    public class ConnectCommand extends SignalCommand {

        [Inject]
        public var parameters:ConnectionAttemptVO;
        [Inject]
        public var queryService:QueryService;

        override public function execute():void {
            queryService.connect(parameters.url, parameters.username, parameters.password);
        }
    }
}
