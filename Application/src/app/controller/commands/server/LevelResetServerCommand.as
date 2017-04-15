package app.controller.commands.server
{
	import app.model.vo.data.LevelVO;
	
	import consts.Request;
	import nest.services.server.commands.ServerCommand;
	
	public final class LevelResetServerCommand extends ServerCommand
	{
		override public function execute( body:Object, userUUID:String ) : void {
			
			const levelVO	: LevelVO = LevelVO(body);
			const data		: Object = {
				uuid 	: userUUID
			,	time	: new Date().getTime()
			,	type	: levelVO.type		
			,	lid		: levelVO.lid
			,	lng		: levelVO.lng
			};
				
			trace("\nServerLevelCompleteCommand");
			
			this.Post(Request.USER_LEVEL_RESET, data, null, true);
		}
	}
}