/**
 * ...
 * @author Vladimir Minkin
 */

package app.model.proxy 
{
	import app.model.proxy.social.SocialFB;
	import app.model.proxy.social.SocialVK;
	
	import nest.patterns.proxy.Proxy;
	
	public class SocialProxy extends Proxy
	{
		
		static public const 		FB_APP_ID			:String = "927580480664348";
		static public const 		FB_APP_SECRET		:String = "c25ee3ee68ddec81d8c9ee2fe40b0abb";
		static public const 		FB_APP_SCOPE		:Array = ['public_profile', 'email', 'user_birthday', 'publish_actions'];

		static public const 		VK_APP_ID			:String = "5074339";
		static public const 		VK_APP_SECRET		:String = "u5EWAtlziibLuTpA9Zxa";
		static public const 		VK_APP_SCOPE		:Array = ['offline', 'wall', 'email'];
		
		private var socialVK		:SocialVK;
		private var socialFB		:SocialFB;
		
		public function SocialProxy()
		{
			super();
		}
		
		public function loginVK(callback:Function):void {
			socialVK = new SocialVK(VK_APP_ID, VK_APP_SCOPE);
			socialVK.login(callback);
		}
		
//		public function logout(callback:Function):void {
//			if(socialVK) socialVK.logout(callback);
//		}
		
		public function loginFB(callback:Function):void {
			socialFB = new SocialFB(FB_APP_ID, FB_APP_SCOPE);
			socialFB.login(callback);
		}
	}
}
