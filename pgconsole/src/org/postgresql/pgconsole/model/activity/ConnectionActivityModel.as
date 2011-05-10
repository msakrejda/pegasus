package org.postgresql.pgconsole.model.activity {
    import org.postgresql.pgconsole.model.activity.vo.NotificationActivityVO;
    import org.postgresql.pgconsole.signal.ResultsSelectedSignal;
    import org.postgresql.pgconsole.model.activity.vo.QueryActivityResponseVO;
    import org.postgresql.pgconsole.model.activity.vo.ConnectionActivityVO;
    import org.postgresql.pgconsole.model.activity.vo.NoticeActivityVO;
    import org.postgresql.pgconsole.model.activity.vo.QueryActivityVO;
    import org.postgresql.pgconsole.model.vo.QueryVO;
    import org.postgresql.pgconsole.signal.ConnectionActivityChangedSignal;
    import mx.collections.ArrayCollection;

    public class ConnectionActivityModel {
        private var _limit:int;
        private var _activityList:ArrayCollection;

        [Inject]
        public var activityChanged:ConnectionActivityChangedSignal;
        [Inject]
        public var resultSelected:ResultsSelectedSignal;

        public function ConnectionActivityModel(limit:int=50) {
            _limit = limit;
            _activityList = new ArrayCollection();
        }

        public function addQuery(query:QueryVO):void {
            addActivity(new QueryActivityVO(query.sql, query.args, []));
        }

        public function selectQueryResult(columns:Array, data:Array):void {
            resultSelected.dispatch(columns, data);
        }

        private function addActivity(activity:ConnectionActivityVO):void {
            if (_activityList.length > _limit) {
                _activityList.removeItemAt(0);
            }
            _activityList.addItem(activity);
            activityChanged.dispatch(_activityList.source);
        }

        public function addNotice(noticeFields:Object):void {
            addActivity(new NoticeActivityVO(noticeFields));
        }

        public function addQueryCompletion(tag:String, rows:int, columns:Array, data:Array):void {
            addActivity(new QueryActivityResponseVO(tag, rows, columns, data));
        }

        public function addNotification(condition:String, notifierPid:int):void {
            addActivity(new NotificationActivityVO(condition, notifierPid));
        }
    }
}
