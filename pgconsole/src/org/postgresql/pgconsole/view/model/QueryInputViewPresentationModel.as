package org.postgresql.pgconsole.view.model {
    import mx.collections.ArrayCollection;
    import org.postgresql.pgconsole.model.vo.QueryVO;
    import org.postgresql.pgconsole.signal.QuerySignal;

    public class QueryInputViewPresentationModel {
        [Inject]
        public var query:QuerySignal;

        public var args:ArrayCollection;

        public function QueryInputViewPresentationModel() {
            args = new ArrayCollection();
        }

        public function execute(sql:String):void {
            var queryArgs:Array;
            if (args.length > 0) {
                queryArgs = [];
                for each (var item:QueryInputViewParameter in args) {
                    queryArgs.push(item.value);
                }
            } else {
                queryArgs = null;
            }
            query.dispatch(new QueryVO(sql, queryArgs));
        }
    }
}
