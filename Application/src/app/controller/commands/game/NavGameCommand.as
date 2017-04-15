package app.controller.commands.game
{
	import flash.system.System;
	
	import app.model.proxy.data.LevelsProxy;
	import app.model.vo.data.LevelVO;
	
	import consts.commands.DataCommands;
	import consts.notifications.GameNotifications;
	
	import nest.interfaces.ICommand;
	import nest.patterns.command.SimpleCommand;
	
	public class NavGameCommand extends SimpleCommand implements ICommand 
	{
		[Inject] public var levelsProxy		: LevelsProxy;
		
		override public function execute( body:Object, type:String ):void 
		{
			const 
				levelVO		: LevelVO 	= LevelVO(levelsProxy.currentLevel)
			,	levelID		: uint 		= levelVO.lid
			,	navitageTo	: int		= int(body)
			;
			
			trace("\nNextGameCommand\n", JSON.stringify(levelVO), body);
			
			this.send( GameNotifications.RESET ); // GameScreenMediator
			this.exec( DataCommands.GET_GAME, levelID + navitageTo ); // LevelsScreen Data Command (GetGameCommand)
			
			System.gc();
			System.pauseForGCIfCollectionImminent(0.1);
		}
	}
}
