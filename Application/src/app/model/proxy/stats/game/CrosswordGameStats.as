package app.model.proxy.stats.game
{
	import app.model.proxy.stats.GameStats;
	
	import consts.Specials;
	
	import nest.utils.TimeUtils;

	[RemoteClass]
	public final class CrosswordGameStats extends GameStats
	{
		public static const NAME:String = "stats_crosswordgame";
		
		public function CrosswordGameStats() { super(NAME); }
		
		private const result:Array = [
			"{prg}: \t\t", 		"1"
		,	"\n{cgt}: \t\t", 	"3"
		,	"\n{agt}: \t\t", 	"5"
		];
		
		override public function toString():String {
			result[1] = progress.join(Specials.GAME_STAT_PROGRESS_DIVIDER);
			result[3] = TimeUtils.timeCode(gametime);
			result[5] = TimeUtils.timeCode(playtime);
			return result.join("");
		}
	}
}