package app.model.proxy
{
	import flash.utils.Dictionary;
	
	import app.model.proxy.stats.IGameStats;
	
	import nest.interfaces.IProxy;
	import nest.patterns.proxy.Proxy;
	
	public final class StatsProxy extends Proxy implements IProxy
	{
		private static const GAME_STATS:String = "stats_game";
		
		public function StatsProxy():void {
			this.setData( new Dictionary() );
		}
		
		public function purgeGameStatistics():void {
			this.data[GAME_STATS] = null;
		}
		
		public function setGameStatistics ( stats:IGameStats ) : void {
			this.data[GAME_STATS] = stats;
		}
		
		public function getGameStatistics() : IGameStats {
			return IGameStats(this.data[GAME_STATS]);
		}
	}
}