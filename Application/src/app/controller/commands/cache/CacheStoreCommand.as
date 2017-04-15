package app.controller.commands.cache
{
	import app.model.proxy.dto.CacheDTO;
	
	import nest.patterns.command.SimpleCommand;
	import nest.services.cache.CacheProxy;
	
	public final class CacheStoreCommand extends SimpleCommand
	{
		[Inject] public var cacheProxy:CacheProxy;
		
		override public function execute( dto:Object, empty:String ):void 
		{
			const cacheDTO:CacheDTO = dto as CacheDTO;
			trace("CacheStoreCommand", cacheDTO.key, cacheDTO.value);
			cacheProxy.store(cacheDTO.key, cacheDTO.value);
		}
	}
}