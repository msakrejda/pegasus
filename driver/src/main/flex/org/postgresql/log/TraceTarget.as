package org.postgresql.log {

    /**
     * An <code>ILogTarget</code> which prints the log messages using the
     * built-in <code>trace</code> function.
     *
     * @see trace
     */
    public class TraceTarget extends AbstractLogTarget {
        /**
         * @inheritDoc
         */
        protected override function doHandleMessage(msg:String):void {
            trace(msg);
        }
    }
}