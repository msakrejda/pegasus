package org.postgresql.pgconsole.signal {
    import org.osflash.signals.Signal;

    public class ConnectionActivityChangedSignal extends Signal {
        public function ConnectionActivityChangedSignal() {
            super(Array);
        }
    }
}
