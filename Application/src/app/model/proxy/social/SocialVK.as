package  app.model.proxy.social {
	
	import flash.data.EncryptedLocalStore;
	import flash.display.BitmapData;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.LocationChangeEvent;
	import flash.geom.Rectangle;
	import flash.media.StageWebView;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import nest.entities.application.Application;

	import starling.core.Starling;
	
	public class SocialVK{
		
		static public const USER_PROFILE:String = "account.getProfileInfo";
		
		private var _appId:String;
		private var _permissions:Array;
		
		private var _uid:String;
		private var _token:String;
		private var _loginCallback:Function;
		
		private var _stageWebView:StageWebView;
		
		public function SocialVK(appId:String, permissions:Array = null)
		{
			_appId = appId;
			if(!permissions) permissions = null;
			_permissions = permissions;
		}
		
		public function login(callback:Function):void
		{
			_stageWebView = new StageWebView();
			_stageWebView.stage = Starling.current.nativeStage;
			_stageWebView.viewPort = new Rectangle(0,0, Application.SCREEN_WIDTH, Application.SCREEN_HEIGHT)
			_loginCallback = callback;
			logout(function(success:Object, fail:Object):void {
				trace(" >> SocialVK: logout", JSON.stringify(success), JSON.stringify(fail));
				if (success) doLogin();
				else callback( null, fail );
			});
		}
		
		private function doLogin():void {
			//Main.log("> VK: doLogin")
			/*
			const oAuth2:OAuth2 = new OAuth2("https://oauth.vk.com/authorize", "https://oauth.vk.com/access_token");
			const grant:IGrantType = new ImplicitGrant(_stageWebView, _appId, "https://oauth.vk.com/blank.html", _permissions.join(','), null, { display:"touch" } );
			oAuth2.addEventListener(GetAccessTokenEvent.TYPE, onGetAccessToken);
			
			function onGetAccessToken(getAccessTokenEvent:GetAccessTokenEvent):void {
				//Main.log("> VK: onGetAccessToken: " + JSON.stringify(getAccessTokenEvent) )
				if (getAccessTokenEvent.errorCode == null && getAccessTokenEvent.errorMessage == null) { // success!
					trace("Your access token value is: " + getAccessTokenEvent.accessToken);
					//Main.log("Your access token value is: " + getAccessTokenEvent.accessToken);
					_token = getAccessTokenEvent.accessToken;
					_uid = getAccessTokenEvent.user_id;
					api(USER_PROFILE, null, HandleUserData);
				}
				else { // fail :(
					trace("Your access token fail!");
					//Main.log("Your access token fail!");
					HandleUserData( null, { error: "Your access token fail!" } );
				}
				oAuth2.removeEventListener(GetAccessTokenEvent.TYPE, onGetAccessToken);
				_stageWebView.dispose();
				_stageWebView = null;
			}
			
			oAuth2.getAccessToken(grant);
			*/
		}
		
		public function logout(callback:Function = null):void
		{
			_uid = null;
			_token = null;
			
			_stageWebView.addEventListener(LocationChangeEvent.LOCATION_CHANGING, OnLocationChange, false, 0, true);
			_stageWebView.addEventListener(LocationChangeEvent.LOCATION_CHANGE, OnLocationChange, false, 0, true);
			_stageWebView.addEventListener(Event.COMPLETE, runLogoutJs);
			_stageWebView.addEventListener(Event.COMPLETE, handleLogout);
			_stageWebView.addEventListener(ErrorEvent.ERROR, handleLogoutError);
			_stageWebView.addEventListener(IOErrorEvent.IO_ERROR, handleLogoutIOError);
			
			_stageWebView.loadURL("http://vk.com/playwords.logic");
			
			var storedValue:ByteArray;
			var hash:String;
			var direct_hash:String;
			var ip_hash:String;
			storedValue = EncryptedLocalStore.getItem("direct_hash");
			if (storedValue) {
				direct_hash = storedValue.readUTFBytes(storedValue.length);
			}
			trace("direct_hash = " + direct_hash);
			storedValue = EncryptedLocalStore.getItem("hash");
			if (storedValue) {
				hash = storedValue.readUTFBytes(storedValue.length);
				trace("hash = " + hash);
			}
			storedValue = EncryptedLocalStore.getItem("ip_h");
			if (storedValue) {
				ip_hash = storedValue.readUTFBytes(storedValue.length);
				trace("ip_h = " + ip_hash);
			}
			
			_stageWebView.loadURL("https://login.vk.com/?act=logout_mobile&amp;hash=" + hash);
			_stageWebView.loadURL("http://oauth.vk.com/logout?hash=" + direct_hash);
			
			if (callback != null) callback( true, null );
			
			function runLogoutJs(event:Event):void {
				Main.log("> VK: runLogoutJs");
				_stageWebView.removeEventListener(Event.COMPLETE, runLogoutJs);
				var jsString:String = "window.location=document.getElementsByClassName('mmi_logout')[0].getElementsByTagName('a')[0].attributes.href;";
				_stageWebView.addEventListener(Event.COMPLETE, handleLogout, false, 0, true);
				try { 
					_stageWebView.loadURL("javascript:" + jsString);
				} catch (e:Error) {
					trace("Type Error:" + e.message)
				}
			}
			
			function handleLogout(event:Event):void {
				Main.log("> VK: handleLogout: " + _stageWebView.location);
				clearLoader();
				if (callback != null) callback( true, null );
			}
			
			function handleLogoutIOError(event:IOErrorEvent):void {
				Main.log("> VK: handleLogoutIOError " + event.text);
				if (callback != null) callback( false, { errorId:event.errorID, text:event.text } );
				clearLoader();
			}
			
			function handleLogoutError(event:ErrorEvent):void {
				Main.log("> VK: handleLogoutError " + event.text);
				if (callback != null) callback( false, { errorId:event.errorID, text:event.text } );
				clearLoader();
			}
			
			function clearLoader():void 
			{
				_stageWebView.removeEventListener(Event.COMPLETE, handleLogout);
				_stageWebView.removeEventListener(ErrorEvent.ERROR, handleLogoutError);
				_stageWebView.removeEventListener(Event.COMPLETE, runLogoutJs);
				_stageWebView.removeEventListener(Event.COMPLETE, handleLogout);
				_stageWebView.removeEventListener(ErrorEvent.ERROR, handleLogoutError);
				_stageWebView.removeEventListener(IOErrorEvent.IO_ERROR, handleLogoutIOError);
			}
		}
		/**
		* Event Handler for onLocationChange
		*
		* Parameters:
		* - event LocationChangeEvent
		*/
		//==================================================================================================
		private function OnLocationChange(e:LocationChangeEvent):void {
		//==================================================================================================
			//Main.log("> onLocationChange : " + e.location)
		}
		
		private function HandleUserData(user:Object, fail:Object):void
		{
			//trace("handleUserData: ", JSON.stringify(success))
			/*
			if(user)
			{
				user.gender = user.sex == 2 ? 'male' : 'female';
				user.id = _uid;
				user.sn = SocialNetwork.VK;
				if(_loginCallback != null) _loginCallback({ user:user, token:_token }, null);
			}
			else
			{
				if(_loginCallback != null) _loginCallback(null, fail);
			}
			_loginCallback = null;
			*/
		}
		
		public function api(method:String, params:Object, callback:Function):void
		{
			var request:URLRequest = new URLRequest("https://api.vkontakte.ru/method/" + method);
			var vars:URLVariables = new URLVariables;
			if(params) for(var param:String in params) {
				vars[param] = params[param];
			}
					
			vars.access_token = _token;
			request.method = URLRequestMethod.GET;
			request.data = vars;
			
			var loader:URLLoader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onVkLoaded, false, 0, true);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onError, false, 0, true);
			loader.load(request);
			
			function onVkLoaded(event:Event):void {
				var response:Object;
				try { response = JSON.parse(loader.data); }
				catch(err:Error) {
					onError(err.message);
				}
				if(!response["error"]) callback(response["response"], null);
				else  onError(response["error"]["error_msg"]);
			}
			
			function onError(message:String):void {
				callback(null, message);
			}
			
		}
		
		public function postWallPhoto(text:String, photoBmd:BitmapData, callback:Function):void
		{
			var uploadUrl:String;
			//var multipartLoader:MultipartURLLoader;
			
			api('photos.getWallUploadServer', {}, handleUploadServer);
			
			function handleUploadServer(success:Object, fail:Object):void
			{
				if(success && success.upload_url)
				{
					uploadUrl = success.upload_url;
					
					//var enc:JPGEncoder = new JPGEncoder(95);
					
					//var rqdata:ByteArray = enc.encode(photoBmd);
					//multipartLoader = new MultipartURLLoader();
					//multipartLoader.addFile(rqdata, "photo.jpg", "photo", 'image/jpeg');
					//multipartLoader.load(success.upload_url);
					//multipartLoader.addEventListener(Event.COMPLETE, completeUpload);
				}
			}

			function completeUpload(event:Event):void
			{
				//var photoUploadResult:Object = JSON.parse(multipartLoader.loader.data);
				//if(photoUploadResult.photo)
				//{
					//api('photos.saveWallPhoto', {server:photoUploadResult.server, photo:photoUploadResult.photo, hash:photoUploadResult.hash}, handlePhotoSaved);
				//}
			}
			
			function handlePhotoSaved(success:Object, fail:Object):void
			{
				if(success)
				{
					var attachmentsStr:String = '';
					for each(var uploadedPhoto:Object in success)
					{
						attachmentsStr += uploadedPhoto.id;
						attachmentsStr += ',';
					}
					attachmentsStr = attachmentsStr.substring(0, attachmentsStr.length-1);
					api('wall.post', {message:text, attachments:attachmentsStr}, handlePostResult);
				}
			}
			
			function handlePostResult(success:Object, fail:Object):void
			{
				if(callback != null)
				{
					callback(success, fail);
				}
			}
		}
		
		public function postLoginPhoto(callback:Function):void
		{
			//var logo:BitmapData = new Logo();
			//postWallPhoto(STRINGS.WALL_POST, logo, callback);
		}

	}
}
