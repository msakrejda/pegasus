package org.postgresql.pgconsole.signal {
    import org.postgresql.pgconsole.model.vo.QueryVO;
    import org.osflash.signals.Signal;

    public class QuerySignal extends Signal {
        public function QuerySignal() {
            super(QueryVO);
        }
    }
}
