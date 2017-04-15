package app.view.components.screens {
	import flash.geom.Point;
	
	import app.model.data.event.GameEventData;
	import app.view.components.bases.GameBase;
	
	import consts.Screens;
	import consts.assets.ButtonAssets;
	import consts.events.Events;

import nest.entities.application.Application;

import nest.entities.assets.Asset;
	import nest.entities.screen.ScrollScreen;
	import nest.interfaces.IGame;
	
	import starling.display.Button;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * ...
	 * @author Vladimir Minkin
	 */
	public class GameScreen extends ScrollScreen 
	{
		public var 
			btnPause		: Button
		;
		
		private var 
			game			: IGame					
		,	_touchCount		: uint
		,	_touchPoint		: Point
		,	_touches		: Vector.<Touch>
		,	_touch			: Touch
		;
		
		public function GameScreen() 
		{
			super(Screens.GAME);
			
			this.isClearWhenRemove = true;
			
			const BUTTONS : ButtonAssets = ButtonAssets.getInstance();
			
			btnPause = Asset(BUTTONS.pause).clone;
			btnPause.x 	= 0;
			btnPause.y 	= 0;
			this.addChild(btnPause);
			
			this.addEventListener(TouchEvent.TOUCH, Handle_Touch)
		}
		
		//==================================================================================================
		override final public function hide(callback:Function = null):void {
		//==================================================================================================
			game.hide();
			super.hide(callback);
		}
		
		//==================================================================================================
		override final public function show():void {
		//==================================================================================================
			super.show();
			game.show();
		}
		
		//==================================================================================================
		override final public function clear():void {
		//==================================================================================================
			resetGame();
		}
		
		public function resetGame():void
		{
			GameBase(game).removeEventListeners();
			game.reset();
			game = null;
		}
		
		//==================================================================================================
		public function addGame(obj:IGame):void {
		//==================================================================================================
			this.game = obj;
			
			var gamebase:GameBase = GameBase(game);
			
			// Все события происходят после обработки основных событий игры
			gamebase.addEventListener(Events.TAP_HAPPEND_ONGAME, 	Handle_GameEvents);
			gamebase.addEventListener(Events.INGAME_ACTION, 		Handle_GameEvents);
			gamebase.addEventListener(Events.TOUCH_START, 			Handle_GameEvents);
			gamebase.addEventListener(Events.TOUCH_END, 			Handle_GameEvents);
			
			this.addChildAt( GameBase(game), 1 );
		}
		
		/**
		 * *************************************************************************************************
		 * HANDLERs
		 */
		//==================================================================================================
		private final function Handle_Touch(e:TouchEvent):void {
		//==================================================================================================
			if(isShow == false) return;
//			_touches = e.touches;
			_touch = e.getTouch(this)
//			_touchCount = uint(_touches.length);
//			if (_touchCount == 2) 
//			{
//				return;
//			}
//			else if (_touchCount == 1 && (_touch = e.getTouch(this))) switch (_touch.phase) 
			if (_touch) switch (_touch.phase) 
			{
				case TouchPhase.BEGAN:
					// Обработчик действия по нажатию в самой игре
					_touchPoint = _touch.getLocation(GameBase(game));
					game.touchstart(_touchPoint); 
					break;
				case TouchPhase.MOVED:
					// Обработчик перемещения в самой игре
					_touchPoint = _touch.getMovement(GameBase(game));
					game.touchmove(_touchPoint); 
					break;
				case TouchPhase.ENDED:
					// Обработчик окончания действия касания
					_touchPoint = _touch.getLocation(GameBase(game));
					// Даем самой игре проверить является ли окончание качания тапом
					if (game.touchend(_touchPoint)) {
						game.tap();
					}; 
					break;
			}
		}
		
		//==================================================================================================
		private final function Handle_GameEvents(event:Event, data:Object):void {
		//==================================================================================================
			var action:String;
			switch (event.type) {
				case Events.TOUCH_START: 		action = GameBase(game).onTouchStart; 	break;
				case Events.TOUCH_END: 			action = GameBase(game).onTouchEnd;		break;
				case Events.TAP_HAPPEND_ONGAME: action = GameBase(game).onTap; 			break;
				case Events.INGAME_ACTION: 		action = GameBase(game).action; 		break;		
			}
			if(action)	this.dispatchEventWith(Events.INGAME_ACTION, false, new GameEventData(action, data) );
		}

		/**
		 * END HANDLERs
		 * *************************************************************************************************
		 */
	}
}
