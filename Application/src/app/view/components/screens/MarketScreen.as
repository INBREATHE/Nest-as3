package app.view.components.screens
{
	import consts.Colors;
	import consts.Defaults;
	import consts.Fonts;
	import consts.Screens;
	import consts.assets.ButtonAssets;

import nest.entities.application.Application;

import nest.entities.assets.Asset;
	import nest.entities.assets.AssetTypes;
	import nest.entities.screen.Screen;
	
	import starling.display.Button;
	import starling.display.Quad;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.utils.Align;
	
	public final class MarketScreen extends Screen
	{
		public static const assets: Object = {
			graphic_buyframe			: new Asset(AssetTypes.GRAPHIC, MarketScreenBuyFrame)
		};
		
		private const
			SF					: Number 	= Application.SCALEFACTOR
		,	TITLE_W				: uint 		= Application.SCREEN_WIDTH * 0.618
		,	SCORE_OFFSET_Y		: int 		= 664 	* SF
		,	SCORE_HEIGHT		: int 		= 40 	* SF
		,	SCORE_FONTSIZE		: int 		= 36 	* SF
		,	SCORE_FONTNAME		: String 	= Fonts.LATO_REGULAR
		,	SCORE_COLOR			: int 		= Colors.WHITE_F1
		;
		
		public var 
			btnBack			: Button
		,	btnQuestion		: Button
		,	btnBuy1			: Button
		,	btnBuy2			: Button
		,	btnBuy3			: Button
		;
		
		private var 
			_txtTitle		: TextField 	= new TextField(1, Defaults.TITLE_HEIGHT, "",
											new TextFormat(Defaults.TITLE_FONT_NAME, Defaults.TITLE_FONT_SIZE * SF, Defaults.TITLE_FONT_COLR))
		,	_txtScore		: TextField 	= new TextField(1, SCORE_HEIGHT, "",
											new TextFormat(SCORE_FONTNAME, SCORE_FONTSIZE, SCORE_COLOR, Align.CENTER))
		;

		//==================================================================================================
		override public function localize(lang:String, data:XMLList = null):void {
		//==================================================================================================
			super.localize(lang, data);
			_txtTitle.text = data.@title;
			
			const titleWidth:uint = _txtTitle.width;
			const titleXPos:uint = (Application.SCREEN_WIDTH - titleWidth) * 0.5;
			
			_txtTitle.x = titleXPos;
			btnQuestion.x = titleXPos + titleWidth + Defaults.BTN_QUESTION_OFF_X * SF;
		}
		
		public function MarketScreen()
		{
			super(Screens.MARKET);
			
			const BUTTONS : ButtonAssets = ButtonAssets.getInstance();
			const titleY:uint = Defaults.TITLE_OFFSET_Y * SF;
			
			btnBack 	= Button(Asset(BUTTONS.close).clone);
			btnBack.x 	= Application.SCREEN_WIDTH - btnBack.width;
			btnBack.y 	= 0;
			this.addChild(btnBack);
			
			btnQuestion 	= Asset(BUTTONS.questionsign).clone;
			btnQuestion.y 	= titleY - btnQuestion.height * 0.5;
			this.addChild(btnQuestion);
			
			_txtTitle.autoSize = TextFieldAutoSize.HORIZONTAL;
			_txtTitle.y = titleY;
			_txtTitle.batchable = true;
			_txtTitle.touchable = false;
			this.addChild(_txtTitle);
			
			const canvasY:uint = 196 * SF;
			const scaleWD:Number = 0.95;
			const buyTexture:Texture = Asset(assets.graphic_buyframe).texture;
			const marginX:uint = 40 * SF;
			const deltaX:uint = buyTexture.width + marginX;
			const xStart:uint = (Application.SCREEN_WIDTH - (deltaX * 3 - marginX)) * 0.5;
			
			btnBuy1 = new Button(buyTexture);
			btnBuy1.x = xStart;
			btnBuy1.y = canvasY;
			btnBuy1.scaleWhenDown = scaleWD;
			this.addChild(btnBuy1);
			
			btnBuy2 = new Button(buyTexture);
			btnBuy2.x = xStart + deltaX;
			btnBuy2.y = canvasY;
			btnBuy2.scaleWhenDown = scaleWD;
			this.addChild(btnBuy2);
			
			btnBuy3 = new Button(buyTexture);
			btnBuy3.x = xStart + deltaX * 2;
			btnBuy3.y = canvasY;
			btnBuy3.scaleWhenDown = scaleWD;
			this.addChild(btnBuy3);
			
			_txtScore.autoSize = TextFieldAutoSize.HORIZONTAL;
			_txtScore.y = SCORE_OFFSET_Y;
			_txtScore.batchable = true;
			_txtScore.touchable = false;
			this.addChild(_txtScore);
		}
		
		public function setUserScore(value:String):void
		{
			_txtScore.text = _locale.@score + value;
			_txtScore.x = (Application.SCREEN_WIDTH - _txtScore.width) * 0.5;
		}
	}
}