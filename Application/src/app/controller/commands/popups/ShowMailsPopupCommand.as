package app.controller.commands.popups
{
	import app.model.proxy.MailsProxy;
	import app.view.components.popups.MailsPopup;
	
	import nest.entities.popup.PopupNotification;
	import nest.interfaces.ICommand;
	import nest.patterns.command.SimpleCommand;
	
	public class ShowMailsPopupCommand extends SimpleCommand implements ICommand 
	{
		[Inject] public var mailsProxy : MailsProxy;
		
		override public function execute( data:Object, type:String ):void 
		{
			trace("ShowMenuPopupCommand");
			const mails:Array = mailsProxy.getData() as Array;
			const popup:MailsPopup = MailsPopup.getInstance();
			trace("\t", mails);
			if(mails.length > 0) {
				popup.prepare(mails);
				this.send(PopupNotification.SHOW_POPUP, popup);
			}
		}
	}
}
