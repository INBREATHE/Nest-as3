package app.controller.commands.reports
{
	import consts.Reports;
	
	import nest.services.reports.commands.ReportCommand;
	
	public final class AppOpenedReportCommand extends ReportCommand
	{
		override public function execute( body:Object, type:String ) : void {
			const date : Date = new Date();
			this.Report( Reports.APP_OPENED, { time: date.time, timezoneOffset: date.timezoneOffset } );
		}
	}
}