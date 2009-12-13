package org.postgresql.febe {
	import org.postgresql.febe.message.IBEMessage;

	public interface IFEBEMessageHandler {
		function getCallback(msg:IBEMessage):Function;
	}
}