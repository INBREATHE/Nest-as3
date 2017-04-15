package app.view.components.elements {
import consts.Colors;
import consts.Defaults;
import consts.Fonts;
import consts.assets.ButtonAssets;
import consts.assets.IconAssets;
import consts.events.Events;

import nest.entities.application.Application;
import nest.entities.assets.Asset;

import starling.animation.Tween;
import starling.core.Starling;
import starling.display.BlendMode;
import starling.display.Button;
import starling.display.DisplayObject;
import starling.display.Image;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.text.TextField;
import starling.text.TextFormat;
import starling.utils.Align;

/**
 * ...
 * @author Vladimir Minkin
 */
public class HudFooter extends Sprite
{
	private const 
		sf						: Number 	= Application.SCALEFACTOR,
		sw						: Number 	= Application.SCREEN_WIDTH,
		sh						: Number 	= Application.SCREEN_HEIGHT,
		
		HUD_FOOTER_HEIGHT		: int		= Defaults.HUD_FOOTER_HEIGHT * sf,
		
		PROGRESS_HEIGHT			: int		= Defaults.HUD_FOOTER_PROGRESS_HEIGHT 	* sf,
		SCORE_FONTSIZE			: int		= 16 	* sf,
		SCORE_WIDTH				: int		= 80 	* sf,
		
		OFFSET_X_SCORE			: int 		= 12 	* sf,
		OFFSET_Y_SCORE			: int 		= 1 	* sf,
		OFFSET_X_ICON_STAR		: int 		= 13 	* sf,
		OFFSET_Y_ICON_STAR		: int 		= 1 	* sf,
		BACKGROUND_COLOR		: uint 		= Colors.HUD_FOOTER_BACK,
		
		THIS_POSITION				: uint 		= sh - HUD_FOOTER_HEIGHT + PROGRESS_HEIGHT
	;
	
	private var 
		progressLine	: Quad
	,	scorePoints		: TextField
	
	,	buttonMarket	: Button
	,	buttonUser		: Button
	;
	
	public function HudFooter() 
	{
		const background:Quad = new Quad(sw, HUD_FOOTER_HEIGHT - PROGRESS_HEIGHT, BACKGROUND_COLOR);
		background.blendMode = BlendMode.NONE;
		background.touchable = false;
		background.x = 0;
		background.y = 0;
		this.addChild(background);
		
		const ICONS		: IconAssets = IconAssets.getInstance();
		
		const iconStar:Image = Image(Asset(ICONS.star).obj);
		iconStar.x = OFFSET_X_ICON_STAR;
		iconStar.y = (HUD_FOOTER_HEIGHT - iconStar.height) * 0.5 + OFFSET_Y_ICON_STAR;
		this.addChild(iconStar);
		
		const BUTTONS		: ButtonAssets = ButtonAssets.getInstance();

		buttonMarket = Button(Asset(BUTTONS.purshase).obj);
		buttonMarket.x = sw - buttonMarket.width - sf;
		buttonMarket.y = 0;
		this.addChild(buttonMarket);

		buttonUser = Button(Asset(BUTTONS.player).obj);
		buttonUser.x = buttonMarket.x - buttonUser.width;
		buttonUser.y = 0;
		this.addChild(buttonUser);
		
		progressLine = new Quad(sw, PROGRESS_HEIGHT, Colors.HUD_PROGRESSBAR);
		progressLine.blendMode = BlendMode.NONE;
		progressLine.touchable = false;
		progressLine.x = 0;
		progressLine.y = 0;//-PROGRESS_HEIGHT * 0.5;
		this.addChild(progressLine);
		
		scorePoints = new TextField(SCORE_WIDTH, HUD_FOOTER_HEIGHT, "0");
		const scorePointsFormat:TextFormat = scorePoints.format;
		scorePointsFormat.font 	= Fonts.LATO_REGULAR;
		scorePointsFormat.color = Colors.HUD_FOOTER_SCORE;
		scorePointsFormat.size 	= SCORE_FONTSIZE;
		scorePointsFormat.horizontalAlign = Align.LEFT;
		scorePoints.x = iconStar.x + iconStar.width + OFFSET_X_SCORE;
		scorePoints.y = OFFSET_Y_SCORE;
		this.addChild(scorePoints);
		
		this.y = THIS_POSITION;
		
		this.addEventListener(Event.TRIGGERED, HandleTriggerEvent);
		
	}
	
	//==================================================================================================
	private function HandleTriggerEvent(e:Event):void {
	//==================================================================================================
		switch (DisplayObject(e.target)) {
			case buttonUser		: 	this.dispatchEventWith( Events.TAP_HAPPEND_USER ); break;
			case buttonMarket	: 	this.dispatchEventWith( Events.TAP_HAPPEND_MARKET ); break;
		}
	}
	
	public function hide(callback:Function):void
	{
		trace("Starling.juggler.containsTweens(this) : ", Starling.juggler.containsTweens(this));
		
		const hideTween:Tween = new Tween(this, Defaults.HUD_FOOTER_ANIM_TIME);	
		hideTween.moveTo(0, Application.SCREEN_HEIGHT);
		hideTween.onComplete = callback;
		Starling.juggler.add(hideTween);
	}
	
	public function show():void
	{
		const showTween:Tween = new Tween(this, Defaults.HUD_FOOTER_ANIM_TIME);	
		showTween.moveTo(0, THIS_POSITION);
		Starling.juggler.add(showTween);
		
	}
	
	public function setScore(value:uint):void 
	{
		scorePoints.text = String(value);
	}
	
	public function addScore(value:uint):void 
	{
		const score:uint = uint(scorePoints.text) + value;
		scorePoints.text = String(score);
	}
}
}
