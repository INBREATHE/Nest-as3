package app.controller.commands.popups
{
	import app.model.proxy.LocalizerProxy;
	import app.view.components.popups.UserPopup;
	
	import nest.entities.popup.PopupNotification;
	import nest.interfaces.ICommand;
	import nest.patterns.command.SimpleCommand;
	
	public class ShowUserPopupCommand extends SimpleCommand implements ICommand 
	{
		[Inject] public var localizerProxy:LocalizerProxy;
		
		override public function execute( data:Object, type:String ):void 
		{
			trace("ShowUserPopupCommand >", type);
			var userPopup:UserPopup = UserPopup.getInstance();
//			userPopup.prepare(/*localizerProxy.getInfoPopupDescription(type)*/);
			this.send(PopupNotification.SHOW_POPUP, userPopup);
		}
	}
}
