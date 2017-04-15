package app.controller.commands.game
{
	import flash.system.System;
	
	import app.model.proxy.data.GameProxy;
	import app.model.proxy.data.LevelsProxy;
	import app.model.vo.data.LevelVO;

	import consts.commands.DataCommands;
	import consts.notifications.GameNotifications;
	import consts.notifications.LevelsNotifications;

	import nest.interfaces.ICommand;
	import nest.patterns.command.SimpleCommand;
	
	public class ResetGameCommand extends SimpleCommand implements ICommand 
	{
		private static const resetData:Object = { completed: 0, progress: 0, playtime: 0, steps:0, answers: "" };
		
		[Inject] public var gameProxy		: GameProxy;
		[Inject] public var levelsProxy		: LevelsProxy;

		override public function execute( body:Object, type:String ):void 
		{
			const 
				levelVO		: LevelVO 	= LevelVO(levelsProxy.currentLevel)
			,	levelID		: uint 		= levelVO.lid
			;

			levelsProxy.updateLevel(levelVO, { data: "" });
			levelsProxy.updateLevel(levelVO, resetData);
			
			gameProxy.resetGame();
			
			trace("\nProcessResetGameCommand\n", JSON.stringify(levelVO));
			
			this.send( GameNotifications	.RESET 				); // GameScreenMediator
			this.send( LevelsNotifications	.RESET, 	levelID ); // LevelsScreenMediator
			this.exec( DataCommands			.GET_GAME, 	levelID ); // GetGameCommand
			
			System.gc();
			System.pauseForGCIfCollectionImminent(0.1);
		}
	}
}
