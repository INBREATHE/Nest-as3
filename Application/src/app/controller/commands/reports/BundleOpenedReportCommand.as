package app.controller.commands.reports
{
	import consts.Reports;
	
	import nest.services.reports.commands.ReportCommand;
	
	public final class BundleOpenedReportCommand extends ReportCommand
	{
		override public function execute( body:Object, type:String ):void 
		{
			this.Report(Reports.BUNDLE_OPENED, { type:type, bundle:String(body) });
		}
	}
}