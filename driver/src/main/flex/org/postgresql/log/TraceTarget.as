package org.postgresql.log {

    public class TraceTarget extends AbstractLogTarget {
        protected override function doHandleMessage(msg:String):void {
            trace(msg);
        }        
    }
}