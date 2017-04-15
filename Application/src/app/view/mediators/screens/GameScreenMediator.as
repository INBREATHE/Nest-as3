package app.view.mediators.screens
{
	import app.model.data.event.GameEventData;
	import app.model.proxy.data.GameProxy;
	import app.view.components.screens.GameScreen;
	
	import consts.commands.DataCommands;
	import consts.commands.PopupCommands;
	import consts.notifications.DataNotifications;
	import consts.notifications.GameNotifications;

	import nest.entities.screen.ScreenMediator;
	import nest.interfaces.IGame;
	import nest.patterns.observer.NFunction;
	
	import starling.events.Event;
	
	public class GameScreenMediator extends ScreenMediator
	{
		[Inject] public var gameProxy:GameProxy;
		
		private var game : IGame;
		private var isPausePopupShown : Boolean = false;
		
		public function GameScreenMediator( viewComponent:Object ) {
			super( viewComponent, DataNotifications.TAKE_GAME, DataCommands.GET_GAME, true );
		}
		
		//==================================================================================================
		override public function listNotificationsFunctions():Vector.<NFunction> {
		//==================================================================================================
			return new <NFunction>[ 
				new NFunction( GameNotifications.UPDATE, 	UpdateGame	)
			,	new NFunction( GameNotifications.RESET, 	ResetGame	)
			];
		}
		
		//==================================================================================================
		override protected function TakeComponentData():void {
		//==================================================================================================
//			const data:GameData = GameData(gameProxy.getData());
//			const type:String = String(gameProxy.gameType);
//			data.isComplete = gameProxy.gameComplete;
//
//			game.build(data);
//
//			GameScreen(screen).addGame(game);
//			screen.isClearWhenRemove = false;
//			ContentReady();
//
//			gameProxy.startGame();
		}
		
		//==================================================================================================
		override protected function Handle_PopupOpened(popupCount:uint, popupName:String):void {
		//==================================================================================================
//			if(popupName == Popups.PAUSE) {
//				screen.isClearWhenRemove = true;
//				this.isBackPossible = true;
//			}
//			else if(popupName == Popups.QUESTION) {
//				screen.isClearWhenRemove = false;
//				this.isBackPossible = false;
//			}
		}
		
		//==================================================================================================
		override protected function Handle_PopupClosed(popupCount:uint, popupName:String):void {
		//==================================================================================================
//			if(popupName == Popups.PAUSE) isPausePopupShown = false;
//			else if(popupName == Popups.QUESTION){
//				this.isBackPossible = true;
//			}
		}
		
		//==================================================================================================
		override protected function Handle_Android_BackButton():void {
		//==================================================================================================
			trace("Handle_Android_BackButton:", isBackPossible);
//			if(!isPausePopupShown) Handle_PauseTap();
//			else {
//				screen.isClearWhenRemove = true;
//				this.isPausePopupShown = false;
//				this.exec( ScreenCommand.CHANGE, null, Screens.PREVIOUS );
//			}
		}
		
		//==================================================================================================
		private function UpdateGame(data:Object):void {
		//==================================================================================================
			game.update(data);
		}
		
		//==================================================================================================
		private function ResetGame():void {
		//==================================================================================================
			RemoveComponentListeners();
			GameScreen(screen).resetGame();
		}
		
		//==================================================================================================
		private function Handle_InGameAction( event:Event, data:Object ):void {
		//==================================================================================================
			this.exec( GameEventData(data).command, GameEventData(data).value );
		}
		
		//==================================================================================================
		private function Handle_PauseTap():void {
		//==================================================================================================
			/** ADNROID - При открытии popup с информацией отключаем восприятие назад  */
			isPausePopupShown = true;
			this.isBackPossible = true;
			this.exec( PopupCommands.SHOW_PAUSE );
		}
		
		//==================================================================================================
		override protected function ComponentTrigger(e:Event):void {
		//==================================================================================================
//			switch (DisplayObject(e.target)) {
//				case GameScreen(screen).btnPause: Handle_PauseTap(); break;
//			}
		}
		
		//==================================================================================================
		override protected function SetupComponentListeners():void {
		//==================================================================================================
//			screen.addEventListener(Events.INGAME_ACTION, Handle_InGameAction	);
		}
		
		//==================================================================================================
		override protected function RemoveComponentListeners():void {
		//==================================================================================================
//			screen.removeEventListener( Events.INGAME_ACTION, Handle_InGameAction);
		}
	}
}
