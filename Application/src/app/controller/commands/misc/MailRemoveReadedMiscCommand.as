package app.controller.commands.misc
{
	import app.model.data.event.MailMessageData;
	import app.model.proxy.MailsProxy;
	
	import consts.notifications.TypesNotifications;
	
	import nest.patterns.command.SimpleCommand;
	
	public final class MailRemoveReadedMiscCommand extends SimpleCommand
	{
		[Inject] public var mailsProxy 		: MailsProxy;
		
		override public function execute( body:Object, type:String ) : void {
			const mdata		: MailMessageData = MailMessageData(body);
			const index		: uint = mdata.id;
			const remove	: Boolean = mdata.remove;
			
			const unreadMailsCount:uint = remove ? mailsProxy.removeMailByIndex(index)
									: 	mailsProxy.readedMailByIndex(index);
			
			trace( "\nMailReadedRemoveMiscCommand", index, unreadMailsCount );
			this.send( TypesNotifications.MAILS_CHANGED, unreadMailsCount );
		}
	}
}