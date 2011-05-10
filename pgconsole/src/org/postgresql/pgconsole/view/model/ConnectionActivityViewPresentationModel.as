package org.postgresql.pgconsole.view.model {
    import org.postgresql.pgconsole.model.activity.vo.QueryActivityResponseVO;
    import org.postgresql.pgconsole.model.activity.vo.ConnectionActivityVO;
    import org.postgresql.pgconsole.signal.SelectResultsSignal;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import org.postgresql.pgconsole.signal.ConnectionActivityChangedSignal;
    import mx.collections.ArrayCollection;

    public class ConnectionActivityViewPresentationModel extends EventDispatcher {
        private var _activity:ArrayCollection;

        [Inject]
        public var connectionActivity:ConnectionActivityChangedSignal;

        [Inject]
        public var selectResult:SelectResultsSignal;

        [PostConstruct]
        public function initialize():void {
            connectionActivity.add(onActivityChanged);
            _activity = new ArrayCollection();
        }

        private function onActivityChanged(activity:Array):void {
            _activity.source = activity;
            var lastActivity:ConnectionActivityVO = ConnectionActivityVO(activity[activity.length - 1]);
            if (lastActivity is QueryActivityResponseVO) {
                selectResult.dispatch(QueryActivityResponseVO(lastActivity));
            }

            dispatchEvent(new Event('activityChanged'));
        }

        [Bindable(event='activityChanged')]
        public function get activity():ArrayCollection {
            return _activity;
        }

        public function showResults(data:QueryActivityResponseVO):void {
            selectResult.dispatch(data);
        }
    }
}
