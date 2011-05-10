package org.postgresql.pgconsole.signal {
    import org.postgresql.pgconsole.model.vo.QueryCompletionVO;
    import org.osflash.signals.Signal;

    public class QueryCompletionSignal extends Signal {
        public function QueryCompletionSignal() {
            super(QueryCompletionVO);
        }
    }
}
