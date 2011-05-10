package org.postgresql.pgconsole.controller {
    import org.postgresql.pgconsole.model.activity.ConnectionActivityModel;
    import org.postgresql.pgconsole.model.vo.QueryVO;
    import org.robotlegs.mvcs.SignalCommand;

    public class AddQueryCommand extends SignalCommand {

        [Inject]
        public var query:QueryVO;

        [Inject]
        public var activityModel:ConnectionActivityModel;

        override public function execute():void {
            activityModel.addQuery(query);
        }

    }
}
