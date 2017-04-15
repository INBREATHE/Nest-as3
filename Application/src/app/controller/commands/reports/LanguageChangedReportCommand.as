package app.controller.commands.reports
{
	import consts.Reports;
	
	import nest.services.reports.commands.ReportCommand;
	
	public final class LanguageChangedReportCommand extends ReportCommand
	{
		/**
		 * Вызывается только из команды SetupLanguageMiscCommand
		 * 
		 * @param body - null
		 * @param type - newLanguage
		 */
		override public function execute( body:Object, type:String ) : void 
		{
			trace("> Report: LanguageChangedEventCommand");
			this.Report(Reports.LANG_CHANGED, { lng: String(body) });
		}
	}
}