package app.controller.commands.reports
{
	import consts.Reports;
	
	import nest.services.reports.commands.ReportCommand;
	
	public final class LevelOpenedReportCommand extends ReportCommand
	{
		override public function execute( lid:Object, gametype:String ):void 
		{
			this.Report(Reports.LEVEL_OPENED, { gametype:gametype, index:int(lid) });
		}
	}
}