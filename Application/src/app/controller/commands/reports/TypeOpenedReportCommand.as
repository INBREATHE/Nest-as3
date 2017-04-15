package app.controller.commands.reports
{
	import consts.Reports;
	
	import nest.services.reports.commands.ReportCommand;

	public final class TypeOpenedReportCommand extends ReportCommand
	{
		override public function execute( body:Object, type:String ):void 
		{
			this.Report(Reports.TYPE_OPENED, { type:String(body) });
		}
	}
}