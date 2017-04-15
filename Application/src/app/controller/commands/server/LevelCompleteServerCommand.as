package app.controller.commands.server
{
	import app.model.proxy.UserProxy;
	import app.model.vo.data.LevelVO;
	
	import consts.Request;
	
	import nest.interfaces.INotifier;
	import nest.services.server.commands.ServerCommand;
	import nest.services.server.consts.ServerRequestType;
	
	/**
	 * Эта команда общается с сервером и отправляет ему запрос на сохранение пройденного уровня
	 * При этом сначала запрос кэшируется, и если он прошел успешно то удаляется из кэша
	 *
	 * * ВСЕ SERVER COMMANDS ОТНОСЯТСЯ К ПОЛЬЗОВАТЕЛЬСКИМ ДАННЫМ
	 * * ПОЭТОМУ НЕОБХОДИМО ЧТОБЫ ОН БЫЛ ЗАРЕГИСТРИРОВАН
	 * 
	 */
	public final class LevelCompleteServerCommand extends ServerCommand
	{
		[Inject] public var userProxy : UserProxy;
		
		override public function execute( body:Object, type:String ) : void {
			const levelVO	: LevelVO = LevelVO(body);
			const notifier	: INotifier = this;
			const data		: Object = {
					uuid 	: userProxy.userUUID
				,	time	: new Date().getTime()
				,	type	: levelVO.type		
				,	lid		: levelVO.lid
				,	lng		: levelVO.lng
			};
			const path:String = Request.USER_LEVEL_COMPLETE;
			trace("LevelCompleteServerCommand", JSON.stringify(data));
			
			// Сначала кэшируем запрос, на случай если пользователь закроет окно раньше чем придет ответ
			// Только если пользователь зарегистрирован мы можем обработать запрос
			if(userProxy.userRegistered) this.Post( path, data, null, true );
			else this.Cache( ServerRequestType.POST, path, data );
		}
	}
}