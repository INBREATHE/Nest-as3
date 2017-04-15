package app.controller.commands.popups
{
	import flash.geom.Point;
	
	import app.model.data.popup.MessagePopupData;
	import app.model.proxy.LocalizerProxy;
	import app.view.components.popups.MessagePopup;
	
	import nest.entities.popup.PopupNotification;
	import nest.interfaces.ICommand;
	import nest.patterns.command.SimpleCommand;
	
	public class ShowMessagePopupCommand extends SimpleCommand implements ICommand 
	{
		[Inject] public var localizerProxy:LocalizerProxy;
		
		override public function execute( data:Object, type:String ):void 
		{
			trace("ShowMessagePopupCommand >", type);
			const popup		: MessagePopup = MessagePopup.getInstance();
			const locale	: XMLList = localizerProxy.getLocaleForPopup(popup.name);
			const text		: Array = [locale[String(type)].@text, "\n\n", locale.@close];
			
			popup.prepare(new MessagePopupData(text.join(""), Point(data)));
			this.send(PopupNotification.SHOW_POPUP, popup);
		}
	}
}
