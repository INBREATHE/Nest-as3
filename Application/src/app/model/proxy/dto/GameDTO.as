package app.model.proxy.dto
{
	import app.model.data.game.base.GameData;
	import app.model.proxy.stats.GameStats;

	public final class GameDTO
	{
		public var stats	: GameStats;
		public var data		: GameData;
	}
}