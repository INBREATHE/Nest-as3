/**
 * ...
 * @author Vladimir Minkin
 */

package app.view.mediators.screens 
{
	
	import flash.geom.Point;
	
	import app.model.data.popup.ConfirmPopupData;
	import app.model.proxy.LocalizerProxy;
	import app.model.proxy.UserProxy;
	import app.view.components.screens.MarketScreen;
	
	import consts.Confirms;
	import consts.Messages;
	import consts.Prices;
	import consts.commands.PopupCommands;
	import consts.commands.PurchaseCommands;
	import consts.notifications.DataNotifications;
	import consts.notifications.HudFooterNotification;
	import consts.notifications.MarketNotifications;

import nest.entities.screen.Screen;

import nest.entities.screen.ScreenCommand;
	import nest.entities.screen.ScreenMediator;
	import nest.interfaces.INotifier;
	import nest.patterns.observer.NFunction;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class MarketScreenMediator extends ScreenMediator
	{
		[Inject] public var userProxy		:UserProxy;
		[Inject] public var localizerProxy	:LocalizerProxy;
			
		public function MarketScreenMediator( viewComponent:Object ) {
			super( viewComponent, DataNotifications.TAKE_PURSHASES, null /*DataCommands.GET_PURSHASES*/, true );
		}
		
		//==================================================================================================
		override public function listNotificationsFunctions():Vector.<NFunction> {
		//==================================================================================================
			return new <NFunction>[ 
				new NFunction( MarketNotifications.PURCHASE_COMPLETE, 	Notification_Purchase_Complete )
			,	new NFunction( MarketNotifications.PURCHASE_FAILED, 	Notification_Purchase_Failed )
			];
		}
		
		//==================================================================================================
		override protected function TakeComponentData():void {
		//==================================================================================================
			SetUserLogicQuantity();
			ContentReady();
		}
		
		//==================================================================================================
		override protected function Handle_Android_BackButton():void {
		//==================================================================================================
			Handle_BackTap();
		}
		
		private function Notification_Purchase_Complete(priceType:String):void
		{
			this.exec( PopupCommands.SHOW_CONFIRM, new ConfirmPopupData( Confirms.BOUGHT, null), priceType);
			SetUserLogicQuantity();
		}
		
		private function Notification_Purchase_Failed():void
		{
			
		}
		
		private function SetUserLogicQuantity():void
		{
			const userScore:String = GetLogicStringForScore(userProxy.userScore);
			MarketScreen(screen).setUserScore(userScore);
		}
		
		private function GetLogicStringForScore(value:uint):String {
			const logic:Array = localizerProxy.getStringByKey("logic").split(",");
			const result:String = String(value) + " " + logic[((value > 1 && value % 10 != 1) || value == 11 ? 1 : 0)];
			return result;
		}
		
		//==================================================================================================
		private function Handle_BuyTap(priceType:String):void {
		//==================================================================================================
			const that:INotifier = this;
			this.exec( PopupCommands.SHOW_CONFIRM, new ConfirmPopupData( Confirms.BUY, function(confirmed:Boolean):void {
				if(confirmed) that.exec( PurchaseCommands.MARKET, priceType );
			}), priceType );
		}
		
		//==================================================================================================
		private function Handle_BackTap():void {
		//==================================================================================================
			trace("\nBackTouchHandler");
			screen.isClearWhenRemove = true;
			this.send( HudFooterNotification.SHOW );
			this.exec( ScreenCommand.CHANGE, null, Screen.PREVIOUS );
		}
		
		//==================================================================================================
		protected function Handle_Show_InformationPopup(target:DisplayObject):void {
		//==================================================================================================
			this.exec( PopupCommands.SHOW_MESSAGE, new Point(target.x, target.y), Messages.MARKET);
		}
		
		//==================================================================================================
		override protected function ComponentTrigger(e:Event):void {
		//==================================================================================================
			switch (DisplayObject(e.target)) {
				case MarketScreen(screen).btnBack: Handle_BackTap(); break;
				case MarketScreen(screen).btnQuestion: Handle_Show_InformationPopup(DisplayObject(e.target)); break;
				case MarketScreen(screen).btnBuy1: Handle_BuyTap(Prices.LOW); break;
				case MarketScreen(screen).btnBuy2: Handle_BuyTap(Prices.MED); break;
				case MarketScreen(screen).btnBuy3: Handle_BuyTap(Prices.HIGH); break;
			}
		}
	}
}
