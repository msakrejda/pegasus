package org.postgresql.febe.message {

    import org.postgresql.febe.message.IBEMessage;
    import org.postgresql.io.ICDataInput;

    public class ErrorResponse extends AbstractInfoMessage implements IBEMessage {

        public override function read(input:ICDataInput):void {
            // The abstract parent class really does everything we need--there is
            // no need to change anything so we just call the superclass implementation
            super.read(input);
        }
        
    }
}