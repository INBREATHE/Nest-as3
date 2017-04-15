package app.controller.commands.reports
{
	import consts.Reports;
	
	import nest.services.reports.commands.ReportCommand;

	public final class InfoShownReportCommand extends ReportCommand
	{
		override public function execute( body:Object, type:String ):void 
		{
			this.Report(Reports.INFO_OPENED, { screen: String(body), type:type });
		}
	}
}