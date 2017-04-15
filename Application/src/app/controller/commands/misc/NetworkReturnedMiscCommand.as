package app.controller.commands.misc
{
	import app.model.proxy.UserProxy;
	
	import consts.commands.ServerCommands;
	
	import nest.entities.application.ApplicationCommand;
	import nest.patterns.command.SimpleCommand;

	public final class NetworkReturnedMiscCommand extends SimpleCommand
	{
		[Inject] public var userProxy : UserProxy;
		
		override public function execute( body:Object, type:String ) : void {
			trace("NetworkReturnedCommmand");
			// If cache has any events we send it to server
			if( userProxy.userRegistered ) {
				this.exec( ApplicationCommand.CACHE_BATCH_REPORT );
				this.exec( ApplicationCommand.CACHE_BATCH_REQUESTS );
				this.exec( ServerCommands.GET_USER_MAILS );
			} else {
				this.exec( ServerCommands.REGISTER_USER, userProxy.getUser() );
			}
		}
	}
}