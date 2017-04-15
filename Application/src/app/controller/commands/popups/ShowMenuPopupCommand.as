package app.controller.commands.popups
{
	import app.model.proxy.LocalizerProxy;
	import app.view.components.popups.MenuPopup;
	
	import nest.entities.popup.PopupNotification;
	import nest.interfaces.ICommand;
	import nest.patterns.command.SimpleCommand;
	
	public class ShowMenuPopupCommand extends SimpleCommand implements ICommand 
	{
		[Inject] public var localizer : LocalizerProxy;
		
		override public function execute( data:Object, type:String ):void 
		{
			trace("ShowMenuPopupCommand");
			var popup:MenuPopup = MenuPopup.getInstance();
				popup.prepare(localizer.languages);
			this.send(PopupNotification.SHOW_POPUP, popup);
		}
	}
}
