package org.postgresql.pgconsole.signal {
    import org.postgresql.pgconsole.model.vo.NoticeVO;
    import org.osflash.signals.Signal;

    public class NoticeSignal extends Signal {
        public function NoticeSignal() {
            super(NoticeVO);
        }
    }
}
