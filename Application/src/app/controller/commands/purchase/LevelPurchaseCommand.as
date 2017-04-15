package app.controller.commands.purchase
{
	import app.model.data.popup.ConfirmPopupData;
	import nest.services.database.DatabaseProxy;
	import app.model.proxy.UserProxy;
	
	import consts.Confirms;
	import consts.commands.PopupCommands;
	
	import nest.patterns.command.SimpleCommand;
	
	public final class LevelPurchaseCommand extends SimpleCommand
	{
		[Inject] public var userProxy 		: UserProxy;
		[Inject] public var databaseProxy 	: DatabaseProxy;
		
		override public function execute( body:Object, type:String ) : void {
			trace( "\nMakePurchaseMiscCommand" );
			
			this.exec( PopupCommands.SHOW_CONFIRM, new ConfirmPopupData(Confirms.BUY_LEVEL, function(confirm:Boolean):void{
				if(confirm) {
					
				} else {
					
				}
			}));
		}
	}
}