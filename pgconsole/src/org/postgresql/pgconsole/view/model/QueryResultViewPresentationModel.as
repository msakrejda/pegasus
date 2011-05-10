package org.postgresql.pgconsole.view.model {
    import org.postgresql.db.IColumn;
    import mx.collections.ArrayCollection;
    import org.postgresql.pgconsole.signal.ResultsSelectedSignal;

    public class QueryResultViewPresentationModel {
        [Inject]
        public var resultsSelected:ResultsSelectedSignal;

        [PostConstruct]
        public function initialize():void {
            resultsSelected.add(onResultsSelected);
        }

        private function onResultsSelected(columns:Array, data:Array):void {
            var newCols:Array = columns.map(function(col:IColumn, index:int, array:Array):String {
                return col.name;
            });
            columnNames = newCols;
            dataProvider = new ArrayCollection(data);
        }

        [Bindable]
        public var columnNames:Array;

        [Bindable]
        public var dataProvider:ArrayCollection;
    }
}
