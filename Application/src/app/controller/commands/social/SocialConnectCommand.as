/**
 * ...
 * @author Vladimir Minkin
 */

package app.controller.commands.social {
	
	import app.model.data.popup.ConfirmPopupData;
	import nest.services.database.DatabaseProxy;
	import nest.services.network.NetworkProxy;
	import app.model.proxy.SocialProxy;
	import app.model.proxy.UserProxy;
	
	import consts.Confirms;
	import consts.commands.PopupCommands;
	import consts.notifications.UserNotifications;
	import consts.social.SocialNetwork;
	
	import nest.interfaces.ICommand;
	import nest.interfaces.INotifier;
	import nest.patterns.command.SimpleCommand;
	
	public class SocialConnectCommand extends SimpleCommand implements ICommand 
	{
		[Inject] public var userProxy			: UserProxy;
		[Inject] public var networkProxy		: NetworkProxy;
		[Inject] public var databaseProxy		: DatabaseProxy;
		[Inject] public var socialProxy			: SocialProxy;
		
		override public function execute( body:Object, type:String ):void 
		{
			trace("\nSocialConnectCommand", body);
			const that:INotifier = this;
			if(networkProxy.isNetworkAvailable) {
				switch(String(body)) {
					case SocialNetwork.FB: break;
					case SocialNetwork.VK: 
						socialProxy.loginVK(function (data:Object, error:Object):void {
							trace("data", JSON.stringify(data), error);
							if (data) {
								UpdateUserSocialParams(data);
								that.send( UserNotifications.LOGIN_SUCCESS, SocialNetwork.VK );
							} else that.send( UserNotifications.LOGIN_FAILED );
						})
					break;
				}
			} else {
				this.exec( PopupCommands.SHOW_CONFIRM, 
					new ConfirmPopupData(Confirms.NO_NETWORK, function():void {
						that.send( UserNotifications.LOGIN_FAILED );
				}, true));
			}
		}
		
		private function UpdateUserSocialParams(input:Object):void {
			const user	: Object = input.user;
			const token	: String = input.token;
			
			userProxy.socialToken = token;
			userProxy.userSocial = user;
		}
		
	}
}
