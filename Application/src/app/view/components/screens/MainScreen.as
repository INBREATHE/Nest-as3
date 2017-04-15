package app.view.components.screens {

import consts.Colors;
import consts.Fonts;
import consts.Screens;
import consts.assets.ButtonAssets;

import nest.entities.application.Application;
import nest.entities.assets.Asset;
import nest.entities.assets.AssetTypes;
import nest.entities.screen.Screen;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.Button;
import starling.display.Canvas;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.text.TextField;
import starling.text.TextFormat;
import starling.textures.Texture;

/**
 * ...
 * @author Vladimir Minkin
 */
public class MainScreen extends Screen
{
	public static const assets: Object = {
		graphic_logo_nestme	:  new Asset( AssetTypes.GRAPHIC, ScreenMainTitleGraphicAsset )
	,	btn_menu_levels		:  new Asset( AssetTypes.BUTTON, ScreenMainMenuLevels )
	,	btn_menu_settings	:  new Asset( AssetTypes.BUTTON, ScreenMainMenuSettings )
	,	btn_menu_credits	:  new Asset( AssetTypes.BUTTON, ScreenMainMenuCredits )
	};

	public var
		btnInfo					: Button
	,	btnMail					: Button
	;

	private const
		SF						: Number	= Application.SCALEFACTOR
	,	MAILS_COUNTER_FONT		: String 	= Fonts.LATO_HEAVY
	,	MAILS_COUNTER_SIZE		: int	 	= 12 * SF
	,	MAILS_COUNTER_COLOR		: uint	 	= Colors.WHITE_FF
	;

	private var
		_animationObjects		: Array = []
	,	_mailsBadge				: Canvas
	,	_mailsCounter			: TextField
	;

	public function MainScreen()
	{
		super(Screens.MAIN);

		const NESTME	: Image = Image(Asset(assets.graphic_logo_nestme).obj);

		const BTN_LEVELS	: Button = Button(Asset(assets.btn_menu_levels).obj);
		const BTN_SETTINGS	: Button = Button(Asset(assets.btn_menu_settings).obj);
		const BTN_CREDITS	: Button = Button(Asset(assets.btn_menu_credits).obj);

		const BUTTONS	: ButtonAssets = ButtonAssets.getInstance();

		btnInfo 	= Asset(BUTTONS.info).obj;
		btnInfo.x 	= Application.SCREEN_WIDTH - btnInfo.width;
		btnInfo.y 	= 0;
		this.addChild(btnInfo);

		btnMail		= Asset(BUTTONS.mail).obj;
		btnMail.x 	= 0;
		btnMail.y 	= 0;
		btnMail.enabled = true;
		this.addChild(btnMail);

		const circle:Canvas = new Canvas();
		circle.drawCircle(0,0, 12 * SF);

		_mailsBadge = circle;
		_mailsCounter = new TextField(
			_mailsBadge.width, _mailsBadge.height,
			"", new TextFormat(MAILS_COUNTER_FONT, MAILS_COUNTER_SIZE, MAILS_COUNTER_COLOR)
		);

		_mailsBadge.x = btnMail.x + btnMail.width - 20 * SF;
		_mailsBadge.y = btnMail.y + 5 * SF;
		_mailsCounter.x = _mailsBadge.x;
		_mailsCounter.y = _mailsBadge.y - SF;

		NESTME.x = 216 * SF;
		NESTME.y = 162 * SF;
		this.addChild(NESTME);

		BTN_LEVELS.x = 426 * SF;
		BTN_LEVELS.y = 292 * SF;
		this.addChild(BTN_LEVELS);

		BTN_SETTINGS.x = BTN_LEVELS.x;
		BTN_SETTINGS.y = 382 * SF;
		this.addChild(BTN_SETTINGS);

		BTN_CREDITS.x = BTN_LEVELS.x;
		BTN_CREDITS.y = 472 * SF;
		this.addChild(BTN_CREDITS);
	}

	public function setUserMailsCount(value:uint):void {
		if(value > 0) {
			if(value > 9) _mailsCounter.text = ">";
			else _mailsCounter.text = value.toString();
			this.addChild(_mailsBadge);
			this.addChild(_mailsCounter);
		} else {
			this.removeChild(_mailsBadge);
			this.removeChild(_mailsCounter);
		}
	}

	//==================================================================================================
	override public function show():void {
	//==================================================================================================
		super.show();

		if(_animationObjects.length > 0) {
			var tween:Tween;
			var fisrtween:Tween;
			var prevtween:Tween;
			_animationObjects.forEach(function(item:DisplayObject, index:uint, arr:Array):void {
				tween = new Tween(item, 0.4);
				tween.fadeTo(1);
				if(prevtween) {
					prevtween.nextTween = tween;
					tween.delay = 0.2;
				}
				if(index == 0) fisrtween = tween;
				prevtween = tween;
			});
			tween.onComplete = function ():void { while (_animationObjects.length) _animationObjects.shift(); }
			prevtween.nextTween = tween;
			Starling.juggler.add(fisrtween);
		}
	}
}
}
