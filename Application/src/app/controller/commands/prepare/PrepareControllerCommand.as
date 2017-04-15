package app.controller.commands.prepare {
	
	import app.controller.commands.complete.LevelCompleteCommand;
	import app.controller.commands.data.GetGameCommand;
	import app.controller.commands.data.GetLevelsCommand;
import app.controller.commands.data.GetMainCommand;
import app.controller.commands.reports.AppOpenedReportCommand;
	import app.controller.commands.reports.InfoShownReportCommand;
	import app.controller.commands.reports.LanguageChangedReportCommand;
	import app.controller.commands.reports.LevelCompletedReportCommand;
	import app.controller.commands.reports.LevelOpenedReportCommand;
	import app.controller.commands.reports.LevelResetReportCommand;
	import app.controller.commands.game.QuitGameCommand;
	import app.controller.commands.game.ResetGameCommand;
	import app.controller.commands.misc.MailRemoveReadedMiscCommand;
	import app.controller.commands.misc.NetworkReturnedMiscCommand;
	import app.controller.commands.misc.SetupLanguageMiscCommand;
	import app.controller.commands.popups.ShowConfirmPopupCommand;
	import app.controller.commands.popups.ShowInfoPopupCommand;
	import app.controller.commands.popups.ShowMailsPopupCommand;
	import app.controller.commands.popups.ShowMenuPopupCommand;
	import app.controller.commands.popups.ShowMessagePopupCommand;
	import app.controller.commands.popups.ShowPausePopupCommand;
	import app.controller.commands.purchase.LevelPurchaseCommand;
	import app.controller.commands.purchase.MarketPurchaseCommand;
	import app.controller.commands.responce.UserMailsResponceCommand;
	import app.controller.commands.server.GetUserMailsServerCommand;
	import app.controller.commands.server.LevelCompleteServerCommand;
	import app.controller.commands.server.LevelResetServerCommand;

	import consts.commands.CompleteCommands;
	import consts.commands.DataCommands;
	import consts.commands.ReportCommands;
	import consts.commands.GameCommands;
	import consts.commands.MiscCommands;
	import consts.commands.PopupCommands;
	import consts.commands.PurchaseCommands;
	import consts.commands.ResponceCommands;
	import consts.commands.ServerCommands;

	import nest.interfaces.ICommand;
	import nest.patterns.command.AsyncCommand;
	
	public class PrepareControllerCommand extends AsyncCommand implements ICommand
	{
		override public function execute( body:Object, type:String ):void 
		{
			facade.registerPoolCommand( DataCommands.GET_LEVELS, 			GetLevelsCommand );
			facade.registerPoolCommand( DataCommands.GET_GAME, 				GetGameCommand );
			facade.registerPoolCommand( DataCommands.GET_MAIN, 				GetMainCommand );

			facade.registerPoolCommand( GameCommands.RESET_GAME, 			ResetGameCommand );
			facade.registerPoolCommand( GameCommands.CLOSE_GAME, 			QuitGameCommand );

			facade.registerCommand( CompleteCommands.LEVEL, 				LevelCompleteCommand );
			
			// POPUPS COMMANDS
			facade.registerCommand( PopupCommands.SHOW_PAUSE,				ShowPausePopupCommand );
			facade.registerCommand( PopupCommands.SHOW_MESSAGE,				ShowMessagePopupCommand );
			facade.registerCommand( PopupCommands.SHOW_CONFIRM,				ShowConfirmPopupCommand );
			facade.registerCommand( PopupCommands.SHOW_INFO,				ShowInfoPopupCommand );
			facade.registerCommand( PopupCommands.SHOW_MENU,				ShowMenuPopupCommand );
			facade.registerCommand( PopupCommands.SHOW_MAILS,				ShowMailsPopupCommand );
			
			// EVENTS -STATISTICS- COMMANDS
			facade.registerCountCommand( ReportCommands.APP_OPENED,			AppOpenedReportCommand, 1 );
			
			facade.registerCommand( ReportCommands.LEVEL_OPENED,			LevelOpenedReportCommand );
			facade.registerCommand( ReportCommands.LEVEL_COMPLT,			LevelCompletedReportCommand );
			facade.registerCommand( ReportCommands.LEVEL_RESET,				LevelResetReportCommand );
			facade.registerCommand( ReportCommands.LNG_CHANGED,				LanguageChangedReportCommand );
			facade.registerCommand( ReportCommands.INFO_SHOWN,				InfoShownReportCommand );
			
			// SERVER -REQUESTS- COMMANDS
			facade.registerCommand( ServerCommands.GET_USER_MAILS, 			GetUserMailsServerCommand );
			facade.registerCommand( ServerCommands.LEVEL_COMPLETE, 			LevelCompleteServerCommand );
			facade.registerCommand( ServerCommands.LEVEL_RESET, 			LevelResetServerCommand );
			
			// SERVER -RESPONCE- COMMANDS
			facade.registerCommand( ResponceCommands.USER_MAILS,			UserMailsResponceCommand );
			
			// MISC COMMANDS
			facade.registerCommand( MiscCommands.NETWORK_RETURNED,			NetworkReturnedMiscCommand );
			facade.registerCommand( MiscCommands.MAIL_READED_REMOVE,		MailRemoveReadedMiscCommand );
			facade.registerCommand( MiscCommands.SETUP_LANGUAGE,			SetupLanguageMiscCommand );
			
			facade.registerCommand( PurchaseCommands.MARKET,				MarketPurchaseCommand );
			facade.registerCommand( PurchaseCommands.LEVEL,					LevelPurchaseCommand );

			commandComplete();
		}
	}
}
