/**
 * ...
 * @author Vladimir Minkin
 */

package app.view.mediators.screens 
{
	
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import app.model.data.popup.ConfirmPopupData;
	import app.model.proxy.LocalizerProxy;
	import app.model.proxy.UserProxy;
	import app.view.components.screens.UserScreen;
	
	import consts.Confirms;
	import consts.Messages;
	import consts.Screens;
	import consts.commands.DataCommands;
	import consts.commands.PopupCommands;
	import consts.commands.SocialCommands;
	import consts.notifications.DataNotifications;
	import consts.notifications.HudFooterNotification;
	import consts.notifications.UserNotifications;

import nest.entities.screen.Screen;

import nest.entities.screen.ScreenCommand;
	import nest.entities.screen.ScreenMediator;
	import nest.interfaces.INotifier;
	import nest.patterns.observer.NFunction;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	public class UserScreenMediator extends ScreenMediator
	{
		[Inject] public var userProxy		:UserProxy;
		[Inject] public var localizerProxy	:LocalizerProxy;
		
		public function UserScreenMediator( viewComponent:Object ) {
			super( viewComponent, DataNotifications.TAKE_USER, DataCommands.GET_USER, true );
		}
		
		//==================================================================================================
		override public function listNotificationsFunctions():Vector.<NFunction> {
		//==================================================================================================
			return new <NFunction>[ 
				new NFunction( UserNotifications.LOGIN_SUCCESS, Notification_LoginSuccess )
			,	new NFunction( UserNotifications.LOGIN_FAILED, 	Notification_LoginFailed )
			];
		}
        
		//==================================================================================================
		private function Notification_LoginSuccess(sn:String):void {
		//==================================================================================================
			const that:INotifier = this;
			const timeoutID:uint = setTimeout(function():void {
				clearTimeout(timeoutID);
				that.exec( PopupCommands.SHOW_CONFIRM, new ConfirmPopupData(Confirms.SYNC, function(confirm:Boolean):void{
					if(confirm) {
						
					} else {
						
					}
				}));
			}, 3000);
//			UserScreen(screen).socialLoginSuccess(sn, localizerProxy.getStringByKey(sn));
		}
		
		//==================================================================================================
		private function Notification_LoginFailed():void {
		//==================================================================================================
			UnLockSocialButtons();
		}
		
		//==================================================================================================
		override protected function TakeComponentData():void {
		//==================================================================================================
			const socialNetwork:String = userProxy.userSocialNetwork;
//			if(socialNetwork) UserScreen(screen).socialLoginSuccess(socialNetwork, localizerProxy.getStringByKey(socialNetwork));
			ContentReady();
		}
		
		//==================================================================================================
		override protected function Handle_Android_BackButton():void {
		//==================================================================================================
			Handle_BackTap();
		}
		
		//==================================================================================================
		protected function Handle_Show_InformationPopup(target:DisplayObject):void {
		//==================================================================================================
			const message:String = userProxy.userSocialNetwork ? Messages.CONNECTED : Messages.SOCIAL;
			this.exec( PopupCommands.SHOW_MESSAGE, new Point(target.x, target.y), message);
		}
		
		//==================================================================================================
		protected function Handle_SocialConnect(socialNetwork:String):void {
		//==================================================================================================
			LockSocialButtons();
			this.exec( SocialCommands.SOCIAL_CONNECT, socialNetwork );
		}
		
		//==================================================================================================
		private function Handle_BackTap():void {
		//==================================================================================================
			trace("\nBackTouchHandler");
			screen.isClearWhenRemove = true;
			this.send( HudFooterNotification.SHOW );
			this.exec( ScreenCommand.CHANGE, null, Screen.PREVIOUS );
		}
		
		private function LockSocialButtons():void
		{
			UserScreen(screen).btnSocialVK.enabled = false;	
		}
		
		private function UnLockSocialButtons():void
		{
			UserScreen(screen).btnSocialVK.enabled = true;	
		}
		
		//==================================================================================================
		override protected function ComponentTrigger(e:Event):void {
		//==================================================================================================
			switch (DisplayObject(e.target)) {
				case UserScreen(screen).btnBack: Handle_BackTap(); break;
				case UserScreen(screen).btnQuestion: Handle_Show_InformationPopup(DisplayObject(e.target)); break;
//				case UserScreen(screen).btnSocialFB: Handle_SocialConnect(SocialNetwork.FB); break;
//				case UserScreen(screen).btnSocialVK: Handle_SocialConnect(SocialNetwork.VK); break;
			}
		}
	}
}
