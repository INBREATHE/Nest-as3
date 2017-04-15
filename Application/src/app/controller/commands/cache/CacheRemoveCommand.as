package app.controller.commands.cache
{
	import nest.patterns.command.SimpleCommand;
	import nest.services.cache.CacheProxy;
	
	public final class CacheRemoveCommand extends SimpleCommand
	{
		[Inject] public var cacheProxy:CacheProxy;
		
		override public function execute( key:Object, empty:String ):void 
		{
			cacheProxy.remove(key as String);
		}
	}
}