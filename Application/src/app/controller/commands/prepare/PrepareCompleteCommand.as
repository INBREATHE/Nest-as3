package app.controller.commands.prepare
{
import app.model.proxy.MailsProxy;
import app.model.proxy.UserProxy;
import app.model.vo.UserVO;

import consts.commands.ReportCommands;
import consts.notifications.HudFooterNotification;
import consts.notifications.TypesNotifications;

import nest.entities.application.ApplicationNotification;
import nest.patterns.command.SimpleCommand;
import nest.services.database.DatabaseProxy;

public class PrepareCompleteCommand extends SimpleCommand
{
	[Inject] public var databaseProxy	: DatabaseProxy;

	[Inject] public var userProxy		: UserProxy;
	[Inject] public var mailsProxy		: MailsProxy;

	override public function execute( body:Object, type:String ):void
	{
		Main(body).hideSplash();

		var user:UserVO = userProxy.getUser();
		if(user) {
			userProxy.userScore = Math.random() * 100;
			this.send( HudFooterNotification.SET_SCORE, user.score );
		}

		this.send( TypesNotifications.MAILS_CAME, mailsProxy.unreadMessages );

		this.exec( ReportCommands.APP_OPENED );
		this.send( ApplicationNotification.INITIALIZED );
	}
}
}
