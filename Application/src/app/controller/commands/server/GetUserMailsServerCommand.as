package app.controller.commands.server
{
	import app.model.proxy.UserProxy;
	
	import consts.Request;
	import consts.commands.ResponceCommands;
	
	import nest.services.server.commands.ServerCommand;
	
	public final class GetUserMailsServerCommand extends ServerCommand
	{
		[Inject] public var userProxy : UserProxy;
		
		/**
		 * Вызывается из:
		 * 1. При запуске игры, команда PrepareCompleteCommand
		 * 2. При смене языка, команда SetupLanguageMiscCommand
		 */
		override public function execute( body:Object, type:String ) : void {
			const data 		: Object 	= { 
				uuid	: userProxy.userUUID
			,	lamid	: userProxy.userLastActiveMailID 
			};
			const path 		: String 	= Request.GET_MAILS;
			const callback 	: String 	= ResponceCommands.USER_MAILS;
			trace("\nGetMailsServerCommand", JSON.stringify(data));
			
			this.Get(path, data, callback);
		}
	}
}