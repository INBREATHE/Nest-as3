package app.view.components.popups 
{
	import consts.Colors;
	import consts.Fonts;
	import consts.Popups;
import consts.assets.ButtonAssets;
import consts.assets.IconAssets;

import nest.entities.application.Application;
	import nest.entities.assets.Asset;
	import nest.entities.popup.Popup;
	import nest.entities.popup.PopupEvents;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.text.TextFormat;
	
	/**
	 * ...
	 * @author Vladimir Minkin
	 */
	public final class MenuPopup extends Popup
	{
		private static var instance:MenuPopup;
		
		private const 
			SCALEFACTOR	:Number 	= Application.SCALEFACTOR
		,	SW			:uint 		= Application.SCREEN_WIDTH
		,	SH			:uint	 	= Application.SCREEN_HEIGHT
		
		,	TITLE_W				:uint 		= SW * 0.618
		,	TITLE_H				:uint 		= 70 * SCALEFACTOR
		,	TITLE_OFFSET_Y		:uint 		= 56 * SCALEFACTOR
		,	TITLE_FONT_NAME		:String 	= Fonts.ROBOTO_CONDENSED
		,	TITLE_FONT_SIZE		:uint 		= 56 * SCALEFACTOR
		,	TITLE_FONT_COLR		:uint 		= Colors.WHITE_F1
		
		,	LANG_H				:uint 		= 40 * SCALEFACTOR
		,	LANG_OFFSET_Y		:uint 		= 224 * SCALEFACTOR
		,	LANG_FONT_NAME		:String 	= Fonts.ROBOTO_CONDENSED
		,	LANG_FONT_SIZE		:uint 		= 28 * SCALEFACTOR
		,	LANG_FONT_COLR		:uint 		= Colors.WHITE_F1
		
		,	LANG_ICON_OFFSET	:uint 		= 64 * SCALEFACTOR
		,	LANG_ICON_DELTA		:uint 		= 16 * SCALEFACTOR
		,	LANG_ICON_TINT		:uint 		= Colors.GREY_66;
		;

		static private const BACK_ALPHA:Number = 1;
		static private const BACK_COLOR:Number = Colors.BLACK_00;

		private var 
			buttonClose		: Button
		,	buttonApply		: Button
		,	activeLang		: Image
		,	langRU			: Image
		,	langEN			: Image
		,	txtTitle		: TextField = new TextField(1, TITLE_H, "", new TextFormat(TITLE_FONT_NAME, TITLE_FONT_SIZE, TITLE_FONT_COLR))
		,	txtLanguage		: TextField = new TextField(1, LANG_H, "", new TextFormat(LANG_FONT_NAME, LANG_FONT_SIZE, LANG_FONT_COLR))
		;	
			
		private const 
			background		: Quad = new Quad(SW, SH, BACK_COLOR)
		,	language		: Array = ["",""]
		;

		private var touch:Touch;
		private var data:Object;
		
		public function MenuPopup() 
		{
			super( Popups.MENU );
			
			const BUTTONS : ButtonAssets = ButtonAssets.getInstance();
			const ICONS : IconAssets = IconAssets.getInstance();

			background.alpha = BACK_ALPHA;
			this.addChild(background);

			const HCENTER:uint = SW * 0.50;

			txtTitle.autoSize = TextFieldAutoSize.HORIZONTAL;
			txtTitle.y = TITLE_OFFSET_Y;
			txtTitle.batchable = true;
			txtTitle.touchable = false;
			this.addChild(txtTitle);

			txtLanguage.autoSize = TextFieldAutoSize.HORIZONTAL;
			txtLanguage.y = LANG_OFFSET_Y;
			txtLanguage.batchable = true;
			txtLanguage.touchable = false;
			this.addChild(txtLanguage);

			buttonClose 	= Asset(BUTTONS.close).clone;
			buttonClose.x 	= SW - buttonClose.width;
			buttonClose.y 	= 0;
			this.addChild(buttonClose);

			buttonApply 	= Asset(BUTTONS.apply).clone;
			buttonApply.x 	= HCENTER - buttonApply.width * 0.5;
			buttonApply.y 	= SH - buttonApply.height - TITLE_OFFSET_Y;
			buttonApply.textFormat.font = Fonts.ROBOTO_CONDENSED;
			buttonApply.textFormat.size = 24 * SCALEFACTOR;
			buttonApply.textFormat.color = Colors.WHITE_FF;
			this.addChild(buttonApply);

			var langYPosition:uint = txtLanguage.y + LANG_ICON_OFFSET;
			langRU = ICONS.langRu.obj as Image;
			langRU.x = HCENTER - langRU.width - LANG_ICON_DELTA;
			langRU.y = langYPosition;
			langRU.name = "ru";
			langRU.color = LANG_ICON_TINT;
			this.addChild(langRU);

			langEN = ICONS.langEn.obj as Image;
			langEN.x = HCENTER + LANG_ICON_DELTA;
			langEN.y = langYPosition;
			langEN.color = LANG_ICON_TINT;
			langEN.name = "en";
			langEN.color = LANG_ICON_TINT;
			this.addChild(langEN);
		}
		
		public static function getInstance():MenuPopup { 
			if (instance == null) instance = new MenuPopup();
			return instance;
		}
		
		override public function localize(data:XMLList):void {
			super.localize(data);
			
			language[0] = data.@lang;
			if(this.data != null) {
				SetCurrentLanguage(activeLang.name);
			}
			
			txtTitle.text = data.@title;
			buttonApply.text = data.@apply;
			
			txtTitle.x = (SW - txtTitle.width) * 0.5;
		}
		
		override public function prepare(input:Object):void {
			var currentLanguage:String = input.current;
			
			this.data = input;
			activeLang = this.getChildByName(currentLanguage) as Image;
			activeLang.color = Colors.WHITE_FF;
			
			SetCurrentLanguage(currentLanguage);
			AdjustElementsBeforeShow();
		}
		
		
		//==================================================================================================
		private function SetCurrentLanguage(currentLanguage:String):void {
		//==================================================================================================
			language[1] = data[currentLanguage];
			txtLanguage.text = language.join(" ");
			txtLanguage.x = (SW - txtLanguage.width) * 0.5;
		}
		
		//==================================================================================================
		private function AdjustElementsBeforeShow():void {
		//==================================================================================================
			background.y = buttonClose.height * 0.5;
			background.x = buttonClose.width * 0.5;
			background.scaleX = 0;
			background.scaleY = 0;
			background.alpha = BACK_ALPHA;
			
			buttonClose.alpha = 0;
			txtLanguage.alpha = 0;
			buttonApply.alpha = 0;
			langRU.alpha = 0;
			langEN.alpha = 0;
			
			txtTitle.alpha = 0;
			txtTitle.y -= TITLE_H * 0.25;
		}
		
		//==================================================================================================
		override public function show():void {
		//==================================================================================================
			var tween1:Tween = new Tween( background, 0.3, Transitions.EASE_OUT );
			var tween2:Tween = new Tween( txtTitle, 0.8, Transitions.EASE_OUT );
			var tween3:Tween = new Tween( txtLanguage, 0.3 );
			var tween4:Tween = new Tween( buttonClose, 0.3 );
			var tween5:Tween = new Tween( buttonApply, 0.3 );
			
			tween1.animate("scaleY", 1);
			tween1.animate("scaleX", 1);
			tween1.animate("x", 0);
			tween1.animate("y", 0);
			
			tween2.delay = 0.2;
			tween2.fadeTo(1);
			tween2.animate("y", txtTitle.y + TITLE_H*0.25);
			tween3.fadeTo(1);
			tween3.onComplete = function():void {
				Starling.juggler.tween( langRU, 0.35, { alpha: 1 });
				Starling.juggler.tween( langEN, 0.35, { alpha: 1 });
			}
			
			tween4.fadeTo(1);
			tween5.fadeTo(1);
			tween5.onComplete = function():void {
				MenuPopup.instance.addEventListener(TouchEvent.TOUCH, HandleTouchEvent);
				MenuPopup.instance.addEventListener(Event.TRIGGERED, HandleTriggerEvent);
			}
			
			tween1.nextTween = tween2;
			tween2.nextTween = tween3;
			tween3.nextTween = tween4;
			tween4.nextTween = tween5;
			
			Starling.juggler.purge();
			Starling.juggler.add(tween1);
		}	
		
		private function HandleTouchEvent(e:TouchEvent):void
		{
			e.stopImmediatePropagation();
			touch = e.getTouch(this, TouchPhase.ENDED);
			if(touch) {
				var target:DisplayObject = touch.target;
				if( activeLang != target && target == langRU || target == langEN ) {
					activeLang.color = LANG_ICON_TINT;
					activeLang = (target as Image);
					activeLang.color = Colors.WHITE_FF;
					language[1] = data[activeLang.name];
					txtLanguage.text = language.join(" ");
				}
			}
		}
		
		//==================================================================================================
		override public function hide(next:Function):void {
		//==================================================================================================
			this.removeEventListener(Event.TRIGGERED, HandleTriggerEvent);
			this.removeEventListener(TouchEvent.TOUCH, HandleTouchEvent);
			
			Starling.juggler.purge();
			
			var tween1:Tween = new Tween( background, 0.4 );
			var tween2:Tween = new Tween( txtTitle, 0.3 );
			var tween4:Tween = new Tween( buttonClose, 0.2 );
			
			tween1.fadeTo(0);
			tween2.fadeTo(0);
			tween4.fadeTo(0);
			
			tween4.nextTween = tween2;
			tween2.nextTween = tween1;
			
			tween1.onCompleteArgs = [instance.name];
			tween1.onComplete = next;
			tween1.delay = 0.25;
			
			Starling.juggler.purge();
			Starling.juggler.add(tween4);
			
			Starling.juggler.tween( txtLanguage, 0.3, 	{ alpha: 0 });
			Starling.juggler.tween( langRU, 0.30, 		{ alpha: 0 });
			Starling.juggler.tween( langEN, 0.30, 		{ alpha: 0 });
			Starling.juggler.tween( buttonApply, 0.3, 	{ alpha: 0 });
		}
		
		//==================================================================================================
		private function HandleTriggerEvent(e:Event):void {
		//==================================================================================================
			e.stopImmediatePropagation();
			switch (DisplayObject(e.target)) 
			{
				case buttonApply:
					this.dispatchEventWith( PopupEvents.COMMAND_FROM_POPUP, false, activeLang.name );
					break;
				case buttonClose:
					this.dispatchEventWith( PopupEvents.TAP_HAPPEND_CLOSE );
					break;
			}
		}
	}
}
