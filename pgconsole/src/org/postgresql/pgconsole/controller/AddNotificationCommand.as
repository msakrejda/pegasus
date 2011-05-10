package org.postgresql.pgconsole.controller {
    import org.postgresql.pgconsole.model.vo.NotificationVO;
    import org.postgresql.pgconsole.model.activity.vo.NotificationActivityVO;
    import org.postgresql.pgconsole.model.activity.ConnectionActivityModel;
    import org.postgresql.pgconsole.model.vo.NoticeVO;
    import org.robotlegs.mvcs.SignalCommand;

    public class AddNotificationCommand extends SignalCommand {
        [Inject]
        public var notification:NotificationVO;

        [Inject]
        public var activityModel:ConnectionActivityModel;

        override public function execute():void {
            activityModel.addNotification(notification.condition, notification.notifierPid);
        }
    }
}
