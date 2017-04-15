package consts.assets 
{
	import nest.entities.assets.Asset;
	import nest.entities.assets.AssetTypes;

	/**
	 * ...
	 * @author Vladimir Minkin
	 */
	public class ButtonAssets 
	{
		static public const instance:ButtonAssets = new ButtonAssets();
		static public function getInstance():ButtonAssets { return instance; }
		static public const assets: Object = {
			button_pause 		: instance.pause
		,	button_mail			: instance.mail
		,	button_menu			: instance.menu
		,	button_info 		: instance.info
		,	button_back			: instance.back
		,	button_ok			: instance.ok
		,	button_close		: instance.close
		,	button_closemail	: instance.closemail
		,	button_arrow		: instance.arrow
		,	button_reload		: instance.reload
		,	button_player		: instance.player
		,	button_purshase		: instance.purshase
		,	button_apply		: instance.apply
		,	button_questionsign	: instance.questionsign
		};
		
		private const BUTTON:int = AssetTypes.BUTTON;
		
		public const 
			pause		: Asset = new Asset(BUTTON, ButtonAssetPause)
		,	menu		: Asset = new Asset(BUTTON, ButtonAssetMenu)
		,	mail		: Asset = new Asset(BUTTON, ButtonAssetMail)
		,	info		: Asset = new Asset(BUTTON, ButtonAssetInfo)
		,	back		: Asset = new Asset(BUTTON, ButtonAssetBack)
		,	ok			: Asset = new Asset(BUTTON, ButtonAssetOk)
		,	close		: Asset = new Asset(BUTTON, ButtonAssetClose)
		,	closemail	: Asset = new Asset(BUTTON, ButtonAssetCloseMail)
		,	arrow		: Asset = new Asset(BUTTON, ButtonAssetArrow)
		,	reload		: Asset = new Asset(BUTTON, ButtonAssetReload)
		,	player		: Asset = new Asset(BUTTON, ButtonAssetPlayer)
		,	purshase	: Asset = new Asset(BUTTON, ButtonAssetPurshase)
		,	apply		: Asset = new Asset(BUTTON, ButtonAssetApply)
		,	questionsign: Asset = new Asset(BUTTON, ButtonAssetQuestionSign)
		;
		
		public function ButtonAssets():void { if (instance) throw new Error("Sorry this is singleton use getInstance() instead."); }
			
	}

}
