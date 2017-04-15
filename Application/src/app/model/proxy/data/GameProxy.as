/**
 * ...
 * @author Vladimir Minkin
 */
package app.model.proxy.data 
{
	import flash.utils.getTimer;
	
	import app.model.data.game.base.GameData;
	
	import nest.interfaces.IProxy;
	import nest.patterns.proxy.Proxy;

	public class GameProxy extends Proxy implements IProxy 
	{
		private var _gameTime		: uint = 0;
		private var _gameType		: String = "";
		private var _gameComplete	: Boolean = false;
		
		private var _startGameTime	: uint = 0;
		private var _pauseGameTime	: uint = 0;
		
		public function get gameComplete():Boolean { return _gameComplete; }
		public function set gameComplete(value:Boolean):void { _gameComplete = value; }

		public function get gameTime():uint 			{ return _gameTime; 	}
		public function get gameType():String 			{ return _gameType; 	}
		public function set gameType(value:String):void { _gameType = value;	}
		
		// Called from GameScreenMediator 
		// inside TakeComponentData method
		public function startGame():void {
			this.resetGame();
			this.resumeGame();
		}
		
		public function pauseGame():uint {
			_pauseGameTime = getTimer();
			_gameTime += Math.floor(_pauseGameTime - _startGameTime);
			return _gameTime;
		}
		
		public function resumeGame():void {
			_startGameTime = getTimer();
		}
		
		public function resetGame():void {
			_gameTime = 0;
		}

		public function get gamedata():Array { return GameData(data).data; }
	}
}
