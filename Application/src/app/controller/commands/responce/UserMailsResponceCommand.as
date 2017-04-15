package app.controller.commands.responce
{
	import app.model.proxy.MailsProxy;
	import app.model.proxy.UserProxy;
	import app.model.vo.MailVO;
	
	import consts.notifications.TypesNotifications;
	
	import nest.patterns.command.SimpleCommand;
	import nest.services.server.consts.ServerStatus;
	
	public final class UserMailsResponceCommand extends SimpleCommand
	{
		[Inject] public var userProxy	: UserProxy;
		[Inject] public var mailsProxy	: MailsProxy;
		
		override public function execute( body:Object, type:String ) : void {
			trace("\nGetMailsResponceCommand", JSON.stringify(body));
			if(body && ServerStatus.EXIST(body) && body.data != null) 
			{
				const mails	: Array = body.data as Array;
				const date	: uint = new Date().getTime();
				const lng	: String = this.getCurrentLanguage();
				
				var length 	: uint = mails.length;
				var mail 	: MailVO;
				var obj		: Object;
				
				mailsProxy.mailsChecked = true;
				
				if(length > 1) mails.sortOn("id", Array.NUMERIC);
				while( length-- ) 
				{
					obj 			= mails.shift();
					mail 			= new MailVO();
					mail.id 		= obj.id;
					mail.title 		= obj.title;
					mail.message 	= obj.message;
					mail.date 		= obj.date 	|| date;
					mail.lng		= obj.lng 	|| lng;
					mailsProxy.storeMail(mail);
				}
				
				userProxy.userLastActiveMailID = mail.id;
				
				this.send( TypesNotifications.MAILS_CAME, mailsProxy.unreadMessages );
			} 
		}
	}
}