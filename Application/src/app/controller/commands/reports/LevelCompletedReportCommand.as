package app.controller.commands.reports
{
	import app.model.vo.data.LevelVO;
	
	import consts.Reports;
	
	import nest.services.reports.commands.ReportCommand;
	
	public final class LevelCompletedReportCommand extends ReportCommand
	{
		override public function execute( body:Object, type:String ):void 
		{
			const levelVO	: LevelVO 	= LevelVO(body);
			this.Report(Reports.LEVEL_COMPLETED, { 
				type	: levelVO.type, 
				lid		: levelVO.lid
			});
		}
	}
}