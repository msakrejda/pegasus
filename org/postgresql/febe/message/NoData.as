package org.postgresql.febe.message
{
    public class NoData extends AbstractMessage implements IBEMessage
    {
        public function read(input:IDataInput):void
        {
            /* do nothing */
        }
        
    }
}