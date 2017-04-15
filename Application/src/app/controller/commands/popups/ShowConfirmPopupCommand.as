package app.controller.commands.popups {

	import app.model.data.popup.ConfirmPopupData;
	import app.model.proxy.LocalizerProxy;
	import app.view.components.popups.ConfirmPopup;
	
	import consts.Confirms;
	import consts.Popups;
	import consts.Prices;
	
	import nest.entities.popup.Popup;
	import nest.entities.popup.PopupNotification;
	import nest.interfaces.ICommand;
	import nest.patterns.command.SimpleCommand;
	
	public class ShowConfirmPopupCommand extends SimpleCommand implements ICommand 
	{
		[Inject] public var localizerProxy		: LocalizerProxy;
		
		override public function execute( body:Object, info:String ):void 
		{
			const data		: ConfirmPopupData = ConfirmPopupData(body);
			const action	: String 	= data.action;
			
			const popup		: Popup 	= ConfirmPopup.getInstance() as Popup;
			const locale	: XMLList 	= localizerProxy.getLocaleForPopup(Popups.CONFIRM)[action];
			const title		: String 	= locale.@title;
			
			var message:String;
			
			switch(action)
			{
				case Confirms.BUY:
				case Confirms.BOUGHT: message = InsertCostInMessage(locale.@message, info); break;
				
				default: message = locale.@message; break;
			}
			
			trace("\nShowConfirmPopupCommand:", message);
			
			
			data.message = message;
			data.title = title;
			
			popup.prepare(data);
			this.send( PopupNotification.SHOW_POPUP, popup );
		}
		
		private function InsertCostInMessage(input:String, priceType:String):String
		{
			const priceCOUNT:uint = Prices.BUY_COUNT[priceType];
			const logicPrice:String = GetLogicStringForScore(priceCOUNT);
			return input.replace("$$", logicPrice);//.replace("##", priceCOST);
		}

		private function GetLogicStringForScore(value:uint):String {
			const logic:Array = localizerProxy.getStringByKey("logic").split(",");
			const result:String = String(value) + " " + logic[((value > 1 && value % 10 != 1) || value == 11 ? 1 : 0)];
			return result;
		}
	}
}
