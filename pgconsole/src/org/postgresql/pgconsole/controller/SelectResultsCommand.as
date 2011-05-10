package org.postgresql.pgconsole.controller {
    import org.postgresql.pgconsole.model.activity.ConnectionActivityModel;
    import org.postgresql.pgconsole.model.activity.vo.QueryActivityResponseVO;
    import org.robotlegs.mvcs.SignalCommand;

    public class SelectResultsCommand extends SignalCommand {

        [Inject]
        public var queryResponse:QueryActivityResponseVO;

        [Inject]
        public var model:ConnectionActivityModel;

        override public function execute():void {
            if (queryResponse.columns && queryResponse.data) {
                model.selectQueryResult(queryResponse.columns, queryResponse.data);
            }
        }
    }
}
