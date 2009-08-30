package org.postgresql.febe.message
{
    public class EmptyQueryResponse extends AbstractMessage implements IBEMessage
    {
        public function read(input:IDataInput):void
        {
            /* do nothing */
        }
        
    }
}