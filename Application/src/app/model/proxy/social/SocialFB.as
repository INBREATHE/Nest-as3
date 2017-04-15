package app.model.proxy.social
{
	import flash.display.BitmapData;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;

	import nest.entities.application.Application;

	public class SocialFB{
		
		private var _appId:String;
		private var _permissions:Array;
		
		private var _uid:String;
		private var _token:String;
		private var _loginCallback:Function;
		
		private var _stageWebView:StageWebView;
		
		public function SocialFB(appId:String, permissions:Array = null)
		{
			_appId = appId;
			if(!permissions) permissions = null;
			_permissions = permissions;
		}
		
		private function InitFBHandler(user:Object, error:Object):void 
		{
			//Main.log("InitFBHandler : " + user)
			if (user) {
				_loginCallback(user, null);
			} else {
				_stageWebView = new StageWebView();
				_stageWebView.viewPort = new Rectangle(0, 0, Application.SCREEN_WIDTH, Application.SCREEN_HEIGHT);
//				FacebookMobile.login(_loginCallback, Starling.current.nativeStage, _permissions, _stageWebView);
			}
		}
		
		public function login(callback:Function):void
		{
			_loginCallback = callback;
//			FacebookMobile.init(_appId, InitFBHandler);
		}
		
		public function logout(callback:Function = null):void
		{
//			FacebookMobile.logout(callback);
		}
		
		public function api(method:String, params:Object, callback:Function):void
		{
			
		}
		
		public function postWallPhoto(text:String, photoBmd:BitmapData, callback:Function):void
		{
			
		}
		
		public function postLoginPhoto(callback:Function):void
		{
			
		}
	}
}
