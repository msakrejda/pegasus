package org.postgresql.pgconsole.controller {
    import org.postgresql.pgconsole.service.QueryService;
    import org.postgresql.pgconsole.model.vo.QueryVO;
    import org.robotlegs.mvcs.SignalCommand;

    public class ExecuteCommand extends SignalCommand {
        [Inject]
        public var query:QueryVO;

        [Inject]
        public var queryService:QueryService;

        override public function execute():void {
            trace('Executing', query);
            queryService.execute(query);
        }
    }
}
