package org.postgresql.pgconsole.controller {
    import org.postgresql.pgconsole.model.activity.ConnectionActivityModel;
    import org.postgresql.pgconsole.model.vo.NoticeVO;
    import org.robotlegs.mvcs.SignalCommand;

    public class AddNoticeCommand extends SignalCommand {
        [Inject]
        public var notice:NoticeVO;

        [Inject]
        public var activityModel:ConnectionActivityModel;

        override public function execute():void {
            activityModel.addNotice(notice.fields);
        }
    }
}
