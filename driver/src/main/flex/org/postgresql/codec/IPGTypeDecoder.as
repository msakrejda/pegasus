package org.postgresql.codec {

    import org.postgresql.febe.message.FieldDescription;
    import org.postgresql.io.ICDataInput;

    public interface IPGTypeDecoder {
        function decode(bytes:ICDataInput, format:FieldDescription):Object;
    }
}