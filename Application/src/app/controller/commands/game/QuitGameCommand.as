package app.controller.commands.game
{
	import app.model.proxy.StatsProxy;
	import app.model.proxy.data.GameProxy;
	import app.model.proxy.data.LevelsProxy;
	import app.model.proxy.stats.IGameStats;
	import app.model.vo.data.LevelVO;
	
	import consts.Screens;
	import consts.notifications.HudFooterNotification;
	import consts.notifications.HudHeaderNotification;
	
	import nest.entities.popup.PopupNotification;
import nest.entities.screen.Screen;
import nest.entities.screen.ScreenCommand;
	import nest.interfaces.ICommand;
	import nest.patterns.command.SimpleCommand;
	
	public class QuitGameCommand extends SimpleCommand implements ICommand 
	{
		private static const updateData:Object = { playtime: 0, steps:0, progress:0 };
		
		[Inject] public var gameProxy	: GameProxy;
		[Inject] public var statsProxy	: StatsProxy;
		[Inject] public var levelsProxy	: LevelsProxy;
		
		override public function execute( body:Object, type:String ):void 
		{
			trace("\nQuitGameCommand");
			
			const levelVO 	: LevelVO = LevelVO(levelsProxy.currentLevel);
			const stats		: IGameStats = statsProxy.getGameStatistics();
			
			updateData.playtime = stats.playtime;
			updateData.steps 	= levelVO.steps;
			updateData.progress = levelVO.progress;
			
			levelsProxy.updateLevel( levelVO, updateData );
			
			gameProxy.resetGame();
			gameProxy.setData(null);
			
			statsProxy.purgeGameStatistics();
			levelsProxy.resetCurrentLevel();
			
			this.send( PopupNotification.HIDE_ALL_POPUPS );
			this.send( HudHeaderNotification.SHOW );
			this.send( HudFooterNotification.SHOW );
			this.exec( ScreenCommand.CHANGE, null, Screen.PREVIOUS );
		}
	}
}
