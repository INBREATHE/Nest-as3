/*
 NEST AS3 SingleCore
 Copyright (c) 2016 Vladimir Minkin <vladimir.minkin@gmail.com>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package nest.services.server.commands
{
import nest.entities.application.ApplicationCommand;
import nest.patterns.command.SimpleCommand;
import nest.services.network.NetworkProxy;
import nest.services.server.entities.ServerProcess;
import nest.services.server.ServerProxy;
import nest.services.server.entities.ServerResponce;

public final class ServerRequestCommand extends SimpleCommand
{
	[Inject] public var serverProxy		: ServerProxy;
	[Inject] public var networkProxy	: NetworkProxy;

	/**
	 * В отличии от ProcessEventCommand эта команда автоматически не сохраняет обрабатываемые ServerProcess
	 * Это нужно делать вручную в callback (функция или команда)
	 */
	//==================================================================================================
	override public function execute( body:Object, type:String ) : void {
	//==================================================================================================
		trace("> Nest -> ServerRequestCommand: " + type, ServerProcess(body).path + " isNetworkAvailable =", networkProxy.isNetworkAvailable);
		if(networkProxy.isNetworkAvailable) serverProxy.serverProcess(type, ServerProcess(body));
		else SendNoNetworkResponce(ServerProcess(body));
	}

	private function SendNoNetworkResponce(process:ServerProcess):void {
		const callback : Object = process.callback;
		if(callback != null)
			this.exec( 	ApplicationCommand.SERVER_RESPONCE,
						ServerResponce.NO_NETWORK(callback)
			);
	}
}
}