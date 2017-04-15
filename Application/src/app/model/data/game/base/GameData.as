package app.model.data.game.base
{
	[RemoteClass]
	public class GameData
	{
		public var isComplete:Boolean = false;

		public var data:Array;
		
		public function GameData() 
		{
			data = new Array();
		}
	}
}
