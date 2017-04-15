/*
 NEST AS3 SingleCore
 Copyright (c) 2016 Vladimir Minkin <vladimir.minkin@gmail.com>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package nest.services.reports.commands
{
import nest.entities.application.ApplicationCommand;
import nest.patterns.command.SimpleCommand;
import nest.services.cache.entities.CacheReport;
import nest.services.network.NetworkProxy;
import nest.services.reports.ReportProxy;

public final class SendReportCommand extends SimpleCommand
{
	[Inject] public var reportProxy 	: ReportProxy;
	[Inject] public var networkProxy 	: NetworkProxy;

	// Before send "report" we stored it, because it's possible that we do not have connection
	// or there will be server error or user will close application before response will come
	// But when server answer on this request ("OK") we remove if from cache in ClearReportCacheCommand

	override public function execute( params:Object, name:String ):void {
		const cacheReport : CacheReport = new CacheReport( name, reportProxy.currentTime, params );
		trace("> Nest -> ReportCommand: " + name + " isNetworkAvailable =", networkProxy.isNetworkAvailable);

		this.exec( ApplicationCommand.CACHE_STORE_REPORT, cacheReport );
		if( networkProxy.isNetworkAvailable ) reportProxy.report( cacheReport );
	}
}
}