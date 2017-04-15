package app.view.components.screens
{
	import consts.Colors;
	import consts.Screens;
	import consts.assets.ButtonAssets;

	import nest.entities.application.Application;

	import nest.entities.assets.Asset;
	import nest.entities.assets.AssetTypes;
	import nest.entities.screen.Screen;
	
	import starling.display.Button;
	import starling.display.Sprite;

	public final class UserScreen extends Screen
	{
		public static const assets: Object = {
			graphic_facebook		:  new Asset(AssetTypes.GRAPHIC, ScreenUserFacebookGraphicAsset)
		,	graphic_vkcom			:  new Asset(AssetTypes.GRAPHIC, ScreenUserVkcomGraphicAsset)
		};
		
		private const
			SF				:Number		= Application.SCALEFACTOR
		;
			
		private const
			_textLayer		: Sprite	= new Sprite()
		;
			
		public var 
			btnQuestion		: Button
		,	btnBack			: Button
		,	btnSocialFB		: Button
		,	btnSocialVK		: Button
		;

		public function UserScreen()
		{
			super(Screens.USER);
			
			const BUTTONS		: ButtonAssets = ButtonAssets.getInstance();
			
			btnBack 	= Asset(BUTTONS.close).clone;
			btnBack.x 	= Application.SCREEN_WIDTH - btnBack.width;
			btnBack.y 	= 0;
			this.addChild(btnBack);
		}
		
		override public function localize(lang:String, data:XMLList=null):void {
			
			super.localize(lang, data);
		}
	}
}