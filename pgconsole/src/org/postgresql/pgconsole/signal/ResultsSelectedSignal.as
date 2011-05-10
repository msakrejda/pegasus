package org.postgresql.pgconsole.signal {
    import org.osflash.signals.Signal;

    public class ResultsSelectedSignal extends Signal {
        public function ResultsSelectedSignal() {
            super(Array, Array);
        }
    }
}
