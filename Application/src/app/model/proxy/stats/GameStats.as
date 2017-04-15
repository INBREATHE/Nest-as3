package app.model.proxy.stats
{
	[RemoteClass]
	public class GameStats implements IGameStats
	{
		public function GameStats(name:String)
		{
			this._name = name;
		}
		
		private var _name:String;
		private var _gameTime:uint;
		private var _playTime:uint;
		private var _steps:uint = 0;
		private var _progress:Array = [0, 0];
		
		public function set steps(value:uint):void { this._steps = value; }
		public function get steps():uint { return _steps; }
		
		public function get playtime():uint { return _playTime; }
		public function get gametime():uint { return _gameTime; }
		
		public function set gametime(value:uint):void { _gameTime = value; }
		public function set playtime(value:uint):void { _playTime = value; }
				
		public function get name():String { 
			return _name;
		}
		
		public function set progress(value:Array):void { _progress = value; }
		public function get progress():Array { return _progress; }
		
		public function toString():String {
			return null;
		}
		
		public function setProgress(value:uint, final:uint):void
		{
			_progress[0] = value;
			_progress[1] = final;
		}
	}
}