package app.model.data.event
{
	public final class GameEventData
	{
		public var command:String;
		public var value:Object;
		
		public function GameEventData(command:String, value:Object) 
		{
			this.command = command;
			this.value = value;
		}
	}
}