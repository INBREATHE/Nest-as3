package consts.assets 
{
import nest.entities.assets.Asset;
import nest.entities.assets.AssetTypes;

/**
 * ...
 * @author Vladimir Minkin
 */
public class IconAssets
{
	static private const instance:IconAssets = new IconAssets();
	static public function getInstance():IconAssets { return instance; }
	static public const assets: Object = {
		icon_star 		: instance.star
	,	icon_protect	: instance.protect
	,	icon_badge 		: instance.badge
	,	icon_readed	 	: instance.readed

	,	icon_langru	 	: instance.langRu
	,	icon_langen	 	: instance.langEn
	};

	private const GRAPHIC:int = AssetTypes.GRAPHIC;

	public const star		: Asset = new Asset(GRAPHIC, IconStarGraphicAssets);
	public const protect	: Asset = new Asset(GRAPHIC, IconProtectGraphicAssets);
	public const badge		: Asset = new Asset(GRAPHIC, IconBadgeGraphicAssets);
	public const readed		: Asset = new Asset(GRAPHIC, IconReadedGraphicAsset);

	public const langRu		: Asset = new Asset(GRAPHIC, IconRuLangGraphicAssets);
	public const langEn		: Asset = new Asset(GRAPHIC, IconEnLangGraphicAssets);

	public function IconAssets():void { if (instance) throw new Error("Sorry this is singleton use getInstance() instead."); }
}
}
