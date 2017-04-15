package app.controller.commands.popups
{
	import app.model.proxy.LocalizerProxy;
	import app.view.components.popups.InfoPopup;
	
	import nest.entities.popup.PopupNotification;
	import nest.interfaces.ICommand;
	import nest.patterns.command.SimpleCommand;
	
	public class ShowInfoPopupCommand extends SimpleCommand implements ICommand 
	{
		[Inject] public var localizerProxy:LocalizerProxy;
		
		override public function execute( data:Object, type:String ):void 
		{
			trace("ShowInfoPopupCommand >", type);
			var infoPopup:InfoPopup = InfoPopup.getInstance();
			infoPopup.prepare(localizerProxy.getInfoPopupDescription(type));
			this.send(PopupNotification.SHOW_POPUP, infoPopup);
		}
	}
}
