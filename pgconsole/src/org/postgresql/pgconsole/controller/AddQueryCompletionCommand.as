package org.postgresql.pgconsole.controller {
    import org.postgresql.pgconsole.model.activity.ConnectionActivityModel;
    import org.postgresql.pgconsole.model.vo.QueryCompletionVO;
    import org.robotlegs.mvcs.SignalCommand;

    public class AddQueryCompletionCommand extends SignalCommand {

        [Inject]
        public var completion:QueryCompletionVO;

        [Inject]
        public var activityModel:ConnectionActivityModel;

        override public function execute():void {
            activityModel.addQueryCompletion(completion.command, completion.affectedRows, completion.columns, completion.data);
        }
    }
}
