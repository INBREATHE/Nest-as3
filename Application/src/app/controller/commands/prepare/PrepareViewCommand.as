package app.controller.commands.prepare {
	
	import flash.display.DisplayObject;
	import flash.events.ProgressEvent;
	import flash.utils.getTimer;
	
	import app.model.proxy.LocalizerProxy;
	import app.view.components.popups.ConfirmPopup;
	import app.view.components.popups.InfoPopup;
	import app.view.components.popups.MailsPopup;
	import app.view.components.popups.MenuPopup;
	import app.view.components.popups.MessagePopup;
	import app.view.components.popups.PausePopup;
	import app.view.components.screens.GameScreen;
	import app.view.components.screens.LevelsScreen;
	import app.view.components.screens.MarketScreen;
	import app.view.components.screens.MainScreen;
	import app.view.components.screens.UserScreen;
	import app.view.mediators.elements.HudFooterMediator;
	import app.view.mediators.elements.HudHeaderMediator;
	import app.view.mediators.screens.GameScreenMediator;
	import app.view.mediators.screens.LevelsScreenMediator;
	import app.view.mediators.screens.MarketScreenMediator;
	import app.view.mediators.screens.MainScreenMediator;
	import app.view.mediators.screens.UserScreenMediator;
	
	import consts.Screens;
	import consts.assets.ButtonAssets;
	import consts.assets.IconAssets;
	import consts.commands.GameCommands;
	import consts.commands.MiscCommands;

	import nest.entities.application.Application;
	import nest.entities.assets.Asset;
	import nest.entities.popup.PopupsMediator;
	import nest.entities.scroller.ScrollerMediator;
	import nest.interfaces.ICommand;
	import nest.patterns.command.AsyncCommand;
	import nest.services.rasterizer.RasterizerService;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Vladimir Minkin
	 */
	public class PrepareViewCommand extends AsyncCommand implements ICommand
	{
		[Inject] public var localizer : LocalizerProxy;
		
		private var 
			_assetName		: String
		,	_assetObject	: Asset
		,	_assetTexture	: Texture
		,	_assetDisplay	: DisplayObject
		,	_assetImage		: Image
		,	_textureDown	: Texture
		,	_functionName	: Function
		,	_scalefactor	: Number
		;

		private var _rasterizerService:RasterizerService;
		
		override public function execute( body:Object, type:String ):void 
		{
			trace("> Nest -> Startup - Prepare: \t View");
			_scalefactor = Application.SCALEFACTOR;
			_rasterizerService = new RasterizerService(
				"gameassets", 
				Starling.current.viewPort,
				function():void {
					AssetsLoadComplete();
				}, "1", 1024, 4096);
			
//			if(_rasterizerService.isCacheExist == false) {
				AssetsLoadFailed();
//			}
			_rasterizerService.process(false);
		}
		
		private function AssetsLoadFailed():void
		{
			var timer:uint = getTimer();
			
			SetVisualAssetForScreen(	ButtonAssets	.assets	);
			SetVisualAssetForScreen(	IconAssets		.assets	);

			SetVisualAssetForScreen(	MainScreen		.assets	);
			SetVisualAssetForScreen(	LevelsScreen	.assets	);
			
			SetVisualAssetForScreen(	UserScreen		.assets	);
			SetVisualAssetForScreen(	MarketScreen	.assets	);
			
			trace("REGISTER ALL GRAPHICS TIME: " + (getTimer() - timer) / 1000);
		}
		
		protected function AssetsLoadingProgress(event:ProgressEvent):void
		{
//			trace("> Nest -> Startup - Assets Loading Progress: " + _gameassets.progress);
		}
		
		protected function AssetsLoadComplete():void
		{
			const lang:String = this.getCurrentLanguage();
			
			GetVisualAssetsForScreen(	ButtonAssets	.assets	);
			GetVisualAssetsForScreen(	IconAssets		.assets	);

			GetVisualAssetsForScreen(	MainScreen		.assets	);
			GetVisualAssetsForScreen(	LevelsScreen	.assets	);

			GetVisualAssetsForScreen(	UserScreen		.assets	);
			GetVisualAssetsForScreen(	MarketScreen	.assets	);
			
//			const crossword:CrosswordGame = CrosswordGame.getInstance();
//			crossword.onTap = PopupCommands.SHOW_QUESTION;
//			crossword.init(new <String>[ GameCommands.ANSWERED_QUESTION ]);
			
			/**
			 * POPUPS INITIALIZATION
			 **/
			const pausePopup:PausePopup = PausePopup.getInstance();
			pausePopup.commands = [	
				GameCommands.RESET_GAME, 
				GameCommands.CLOSE_GAME,
				GameCommands.NAV_GAME
			];
			pausePopup.localize(localizer.getLocaleForPopup(pausePopup.name));

			const confirmPopup:ConfirmPopup = ConfirmPopup.getInstance();
			confirmPopup.commands = [];
			confirmPopup.localize(localizer.getLocaleForPopup(confirmPopup.name));
			
			const infoPopup:InfoPopup = InfoPopup.getInstance();
			infoPopup.commands = [];
			infoPopup.localize(localizer.getLocaleForPopup(infoPopup.name));
			
			const menuPopup:MenuPopup = MenuPopup.getInstance();
			menuPopup.commands = [MiscCommands.SETUP_LANGUAGE];
			menuPopup.localize(localizer.getLocaleForPopup(menuPopup.name));
			
			const mailsPopup:MailsPopup = MailsPopup.getInstance();
			mailsPopup.commands = [MiscCommands.MAIL_READED_REMOVE];
			mailsPopup.localize(localizer.getLocaleForPopup(mailsPopup.name));
			
			const messagePopup:MessagePopup = MessagePopup.getInstance();
			messagePopup.commands = [];
			messagePopup.localize(localizer.getLocaleForPopup(messagePopup.name));
			
			/**/
			/******************************************************/
			/**/
			
			const mainScreen				: MainScreen 			= new MainScreen();
			const mainScreenMediator		: MainScreenMediator 	= new MainScreenMediator	(	mainScreen		);
			
			const levelsScreen				: LevelsScreen 			= new LevelsScreen();
			const levelsScreenMediator		: LevelsScreenMediator 	= new LevelsScreenMediator	(	levelsScreen	);
			
			const gameScreen				: GameScreen 			= new GameScreen();
			const gameScreenMediator		: GameScreenMediator 	= new GameScreenMediator	(	gameScreen		);
			
			const userScreen				: UserScreen 			= new UserScreen();
			const userScreenMediator		: UserScreenMediator 	= new UserScreenMediator	(	userScreen		);
			
			const marketScreen				: MarketScreen 			= new MarketScreen();
			const marketScreenMediator		: MarketScreenMediator 	= new MarketScreenMediator	(	marketScreen	);
			
			mainScreen		.localize(lang, localizer.getLocaleForScreen( Screens.MAIN		));
			levelsScreen	.localize(lang, localizer.getLocaleForScreen( Screens.LEVELS	));
			gameScreen		.localize(lang, localizer.getLocaleForScreen( Screens.GAME		));
			userScreen		.localize(lang, localizer.getLocaleForScreen( Screens.USER		));
			marketScreen	.localize(lang, localizer.getLocaleForScreen( Screens.MARKET	));
			
			this.facade.registerMediatorAdvance( marketScreenMediator );
			this.facade.registerMediatorAdvance( userScreenMediator );
			this.facade.registerMediatorAdvance( mainScreenMediator );
			this.facade.registerMediatorAdvance( levelsScreenMediator );
			this.facade.registerMediatorAdvance( gameScreenMediator );

			this.facade.registerMediatorAdvance(new HudFooterMediator());
			
			this.facade.registerMediator(new HudHeaderMediator());
			this.facade.registerMediator(new ScrollerMediator());
			this.facade.registerMediator(new PopupsMediator());
			
			this.commandComplete();
		}
		
		private function SetVisualAssetForScreen(screenAssets:Object):void {
			for (_assetName in screenAssets) {
				_assetObject = screenAssets[_assetName];
				_assetDisplay = new _assetObject.classlink();
				_rasterizerService.addElementToRaster(_assetDisplay, _assetName, _scalefactor);
			}
		}
		
		private function GetVisualAssetsForScreen(screenAssets:Object):void {
			for (_assetName in screenAssets) {
				_assetObject = screenAssets[_assetName];
				_assetObject.obj = _rasterizerService.getElementByName(_assetName);
//				trace("> get assets > " + _assetName, _assetObject.obj);
			}
		}
	}
}
