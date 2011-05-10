package org.postgresql.pgconsole.signal {
    import org.postgresql.pgconsole.model.vo.ConnectionAttemptVO;
    import org.osflash.signals.Signal;

    public class ConnectSignal extends Signal {
        public function ConnectSignal() {
            super(ConnectionAttemptVO);
        }
    }
}
