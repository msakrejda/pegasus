package org.postgresql.pgconsole.signal {
    import org.postgresql.pgconsole.model.activity.vo.QueryActivityResponseVO;
    import org.postgresql.pgconsole.model.vo.QueryCompletionVO;
    import org.osflash.signals.Signal;

    public class SelectResultsSignal extends Signal {
        public function SelectResultsSignal() {
            super(QueryActivityResponseVO);
        }
    }
}
