package app.controller.commands.popups
{
	import app.model.data.popup.PausePopupData;
	import app.model.proxy.StatsProxy;
	import app.model.proxy.data.GameProxy;
	import app.model.proxy.data.LevelsProxy;
	import app.model.proxy.stats.IGameStats;
	import app.model.vo.data.LevelVO;
	import app.view.components.popups.PausePopup;
	
	import nest.entities.popup.PopupNotification;
	import nest.interfaces.ICommand;
	import nest.patterns.command.SimpleCommand;
	
	import starling.events.Event;
	
	public class ShowPausePopupCommand extends SimpleCommand implements ICommand 
	{
		[Inject] public var gameProxy		: GameProxy;
		[Inject] public var statsProxy		: StatsProxy;
		[Inject] public var levelsProxy		: LevelsProxy;
		
		override public function execute( body:Object, type:String ):void 
		{
			const levelVO		: LevelVO 		= levelsProxy.currentLevel;
			const gameStats		: IGameStats 	= statsProxy.getGameStatistics();
			const pausePopup	: PausePopup 	= PausePopup.getInstance();
			
			trace("ShowPausePopupCommand");
			
			const gameTime:uint = gameProxy.pauseGame();
			const playTime:uint = levelVO.playtime + gameTime;
			
			gameStats.gametime = gameTime;
			gameStats.playtime = playTime;
			
			pausePopup.prepare(
				new PausePopupData( 
					levelVO.completed
				,	gameStats.toString()
				,	levelsProxy.isNextLevelAvailableForCurrentLevel
				,	levelsProxy.isPrevLevelAvailableForCurrentLevel
			));
				
			pausePopup.addEventListener(Event.REMOVED_FROM_STAGE, function(e:Event):void {
				pausePopup.removeEventListeners(Event.REMOVED_FROM_STAGE);
				// this mean that current game is not closed (see CloseGameCommand )
				if(levelsProxy.currentLevel != null) gameProxy.resumeGame();
			});
				
			this.send( PopupNotification.SHOW_POPUP, pausePopup );
		}
	}
}
