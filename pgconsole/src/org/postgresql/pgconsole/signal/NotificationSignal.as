package org.postgresql.pgconsole.signal {
    import org.postgresql.pgconsole.model.vo.NotificationVO;
    import org.osflash.signals.Signal;

    public class NotificationSignal extends Signal {
        public function NotificationSignal() {
            super(NotificationVO);
        }
    }
}
