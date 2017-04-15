package app.model.proxy.stats
{
	public interface IGameStats
	{
		function set playtime(value:uint):void;
		function set gametime(value:uint):void;
		function get playtime():uint;
		function get gametime():uint;
		function get progress():Array;
		function toString():String;
		function setProgress(value:uint, final:uint):void;
	}
}