package app.controller.commands.prepare {
	
	import app.model.vo.DatabaseVO;
	import app.model.vo.ServerVO;
	
	import nest.interfaces.ICommand;
	import nest.patterns.command.AsyncCommand;
	import nest.services.cache.CacheService;
	import nest.services.database.DatabaseService;
	import nest.services.network.NetworkService;
	import nest.services.reports.ReportService;
	import nest.services.server.ServerService;
	
	/**
	 * ...
	 * @author Vladimir Minkin
	 */
	public class PrepareServicesCommand extends AsyncCommand implements ICommand
	{
		override public function execute( body:Object, type:String ):void 
		{
//			trace("> Nest -> Startup - Prepare: \t Services", body);
			
			const serverVO		: ServerVO 		= new ServerVO();
			const databaseVO	: DatabaseVO 	= new DatabaseVO();
			
			NetworkService		.getInstance().init(null);
			CacheService		.getInstance().init(null);
			ServerService		.getInstance().init(serverVO);
			ReportService		.getInstance().init(serverVO);
			DatabaseService		.getInstance().init(databaseVO);
			
			commandComplete();
		}
	}
}
