package app.controller.commands.server
{
	import app.controller.commands.responce.UserRegisteredResponceCommand;
	
	import consts.Request;
	import consts.commands.ResponceCommands;

	import nest.services.server.commands.ServerCommand;
	
	public final class RegisterUserServerCommand extends ServerCommand
	{
		/**
		 * Эта команда вызывается только один при регистрации пользователя
		 * @param body - UserVO
		 * @param type - null
		 */
		override public function execute( userVO:Object, type:String ) : void {
			const data 			: Object 	= userVO;
			const path 			: String 	= Request.USER_REGISTER;
			const callback 		: String 	= ResponceCommands.USER_REGISTERED;
			
			// Эта команда вызывается только один раз после регистрации пользователя
			// Удаляем эту команду потому что она регистрируется только 
			// один раз при запуске команды на регистрацию пользователя
			// ServerCommands.REGISTER_USER - RegisterUserServerCommand
			facade.registerCountCommand(callback, UserRegisteredResponceCommand, 1);
			// Запрос не кэшируется
			this.Post(path, data, callback);
		}
	}
}