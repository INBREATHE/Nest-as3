package app.controller.commands.purchase
{
	import app.model.proxy.UserProxy;
	
	import consts.Prices;
	import consts.notifications.HudFooterNotification;
	import consts.notifications.MarketNotifications;
	
	import nest.patterns.command.SimpleCommand;
	
	public final class MarketPurchaseCommand extends SimpleCommand
	{
		[Inject] public var userProxy 		: UserProxy;
		
		override public function execute( body:Object, type:String ) : void {
			trace( "\nMakePurchaseMiscCommand" );
			
			// priceType это значение из Prices.[LOW, MED. HGH]
			const priceType:String = String(body);
			const scoreCount:uint = Prices.BUY_COUNT[priceType];
			
			userProxy.userScore += scoreCount;
			
			this.send( MarketNotifications.PURCHASE_COMPLETE, priceType );
			this.send( HudFooterNotification.ADD_SCORE, scoreCount );
		}
	}
}