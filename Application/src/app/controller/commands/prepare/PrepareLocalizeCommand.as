package app.controller.commands.prepare
{
import app.model.proxy.DataProxy;
import app.model.proxy.LocalizerProxy;
import app.model.proxy.MailsProxy;
import app.model.proxy.UserProxy;

import consts.notifications.CommonNotifications;

import nest.interfaces.ICommand;
import nest.patterns.command.SimpleCommand;
import nest.services.cache.CacheProxy;
import nest.services.database.DatabaseProxy;
import nest.services.reports.ReportProxy;
import nest.services.server.ServerProxy;
	
public class PrepareLocalizeCommand extends SimpleCommand implements ICommand
{
	[Inject] public var cacheProxy		: CacheProxy;

	[Inject] public var dataProxy 		: DataProxy;
	[Inject] public var userProxy 		: UserProxy;
	[Inject] public var mailsProxy 		: MailsProxy;
	[Inject] public var serverProxy 	: ServerProxy;
	[Inject] public var reportProxy 	: ReportProxy;
	[Inject] public var databaseProxy 	: DatabaseProxy;
	[Inject] public var localizerProxy	: LocalizerProxy;

	override public function execute( body:Object, type:String ):void
	{
		const currentLanguage : String = cacheProxy.language;
		this.facade.currentLanguage = currentLanguage;

		trace("> Nest -> Startup - Prepare: \t Localize", currentLanguage);

		dataProxy		.setupLanguage( currentLanguage );
		userProxy		.setupLanguage( currentLanguage );
		serverProxy		.setupLanguage( currentLanguage );
		reportProxy		.setupLanguage( currentLanguage );
		databaseProxy	.setupLanguage( currentLanguage );
		localizerProxy	.setupLanguage( currentLanguage );

		mailsProxy.reset();
		mailsProxy.loadMails();

		this.send( CommonNotifications.CHANGE_LANGUAGE, currentLanguage );
	}
}
}
