package app.controller.commands.misc
{
	import app.controller.commands.prepare.PrepareLocalizeCommand;
	import app.model.proxy.LocalizerProxy;
	import app.model.proxy.MailsProxy;
	import app.view.components.popups.ConfirmPopup;
	import app.view.components.popups.InfoPopup;
	import app.view.components.popups.MailsPopup;
	import app.view.components.popups.MenuPopup;
	import app.view.components.popups.MessagePopup;
	import app.view.components.popups.PausePopup;

	import consts.Popups;
	import consts.Screens;
	import consts.commands.ReportCommands;
	import consts.commands.ServerCommands;
	import consts.notifications.CommonNotifications;
	import consts.notifications.TypesNotifications;
	
	import nest.entities.screen.ScreenCommand;
	import nest.entities.screen.ScreensProxy;
	import nest.patterns.command.SimpleCommand;

	public final class SetupLanguageMiscCommand extends SimpleCommand
	{
		[Inject] public var mailsProxy 		: MailsProxy;
		[Inject] public var screensProxy 	: ScreensProxy;
		[Inject] public var localizer 		: LocalizerProxy;
		
		private const _LOCALIZE_PROXY_COMMAND:String = "command_localize_all_proxy";
		
		override public function execute( body:Object, type:String ) : void {
			trace("\nSetupLanguageMiscCommand", body);
			const newLanguage:String = String(body);
			if(newLanguage != this.getCurrentLanguage()) {
				
				this.facade.registerCountCommand( _LOCALIZE_PROXY_COMMAND, PrepareLocalizeCommand, 1);
				this.exec( _LOCALIZE_PROXY_COMMAND );
				
				LocalizePopups();
				LocalizeScreens();
				LocalizeElements();
				
				this.send( CommonNotifications.CHANGE_LANGUAGE, newLanguage );
				this.send( TypesNotifications.MAILS_CAME, mailsProxy.unreadMessages );
				this.exec( ReportCommands.LNG_CHANGED, newLanguage );
				this.exec( ServerCommands.GET_USER_MAILS );
			}
		}
		
		private function LocalizePopups():void 
		{
			PausePopup		.getInstance().localize(localizer.getLocaleForPopup(Popups.PAUSE));
			InfoPopup		.getInstance().localize(localizer.getLocaleForPopup(Popups.INFO));
			MenuPopup		.getInstance().localize(localizer.getLocaleForPopup(Popups.MENU));
			MailsPopup		.getInstance().localize(localizer.getLocaleForPopup(Popups.MAILS));
			ConfirmPopup	.getInstance().localize(localizer.getLocaleForPopup(Popups.CONFIRM));
			MessagePopup	.getInstance().localize(localizer.getLocaleForPopup(Popups.MESSAGE));
		}
		
		private function LocalizeScreens():void {
			const lang:String = this.getCurrentLanguage();
			
			this.send( ScreenCommand.LOCALIZE, lang );
			
			screensProxy.getScreenByName(Screens.LEVELS)	.localize(lang, localizer.getLocaleForScreen(Screens.LEVELS));
			screensProxy.getScreenByName(Screens.GAME)		.localize(lang, localizer.getLocaleForScreen(Screens.GAME));
			screensProxy.getScreenByName(Screens.USER)		.localize(lang, localizer.getLocaleForScreen(Screens.USER));
			screensProxy.getScreenByName(Screens.MARKET)	.localize(lang, localizer.getLocaleForScreen(Screens.MARKET));
		}
		
		private function LocalizeElements():void {
			const lang:String = this.getCurrentLanguage();
		}
	}
}