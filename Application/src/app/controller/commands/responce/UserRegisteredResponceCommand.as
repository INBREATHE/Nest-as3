package app.controller.commands.responce
{
	import app.model.proxy.UserProxy;
	
	import consts.commands.ResponceCommands;
	
	import nest.entities.application.ApplicationCommand;
	import nest.patterns.command.SimpleCommand;
	import nest.services.network.NetworkProxy;
	import nest.services.server.consts.ServerStatus;
	
	public final class UserRegisteredResponceCommand extends SimpleCommand
	{
		[Inject] public var userProxy		: UserProxy;
		[Inject] public var networkProxy	: NetworkProxy;
		
		/**
		 * This command is called only once when user registering
		 */
		override public function execute( serverResult:Object, type:String ) : void {
			trace("> App -> UserRegisterResponceCommand", serverResult);
			if( ServerStatus.ALLOW( serverResult ) )  {
				trace("\t\tOK");
				userProxy.userRegistered = true;
				
				// When user register we ask server about his mails
				this.exec( ResponceCommands.USER_MAILS, serverResult );
				
				if(networkProxy.isNetworkAvailable) {
					// Events and Requests will be not processed by server
					// if user is not registered before
					this.exec( ApplicationCommand.CACHE_BATCH_REPORT );
					this.exec( ApplicationCommand.CACHE_BATCH_REQUESTS );
				}
			}
		}
	}
}