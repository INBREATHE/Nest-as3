package app.controller.commands.reports
{
	import consts.Reports;
	
	import nest.services.reports.commands.ReportCommand;
	
	public final class LevelResetReportCommand extends ReportCommand
	{
		override public function execute( body:Object, type:String ):void 
		{
			this.Report(Reports.LEVEL_RESET, { type:type, index:int(body) });
		}
	}
}