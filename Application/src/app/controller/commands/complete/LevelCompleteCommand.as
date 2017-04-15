package app.controller.commands.complete
{
	import app.model.proxy.UserProxy;
	import app.model.proxy.data.LevelsProxy;
	import app.model.vo.data.LevelVO;

	import consts.commands.ReportCommands;
	import consts.commands.ServerCommands;
	import consts.notifications.HudFooterNotification;
	import consts.notifications.LevelsNotifications;

	import nest.interfaces.ICommand;
	import nest.patterns.command.SimpleCommand;

	public class LevelCompleteCommand extends SimpleCommand implements ICommand 
	{
		[Inject] public var userProxy		: UserProxy;
		[Inject] public var levelsProxy		: LevelsProxy;

		override public function execute( body:Object, type:String ):void 
		{
			trace("\nLevelCompleteCommand\n");
			
			var levelVO			: LevelVO 	= levelsProxy.currentLevel;
			var levelID			: uint 		= levelVO.lid;

			const levelScore	: int		= levelVO.score;

			const levels		: Array 	= levelsProxy.getData() as Array;

			levelsProxy.updateLevel( levelVO, { completed: 1 } );
			userProxy.userScore += levelScore;
			
			var unlock	: Object = { locked: 0 };
			var counter	: uint 	= levelID + 1;
			var length	: uint 	= levels.length;
			var locked	: int 	= 1;
			if (counter < length) {
				levelVO = LevelVO(levels[counter]);
				locked = levelVO.locked;
				if (locked == 1) {
					levelID = levelVO.lid;
					levelsProxy.updateLevel( levelVO, unlock );
					// Обновляем дерево уровней пользователя
					userProxy.addLevelToGameTree(levelID);
					this.send( LevelsNotifications.UNLOCK, levelID );
				}
			}
			
			trace(JSON.stringify(userProxy.userGameTree));
			
			this.send( HudFooterNotification.ADD_SCORE, levelScore );
			this.send( LevelsNotifications.COMPLETE, levelID );
			
			this.exec( ReportCommands.LEVEL_COMPLT, levelVO );
			this.exec( ServerCommands.LEVEL_COMPLETE, levelVO );
		}
	}
}
