package app.view.components.popups 
{
	import consts.Colors;
	import consts.Defaults;
	import consts.Fonts;
	import consts.Popups;
	import consts.assets.ButtonAssets;
	
	import nest.entities.application.Application;
	import nest.entities.assets.Asset;
	import nest.entities.popup.Popup;
	import nest.entities.popup.PopupEvents;
	
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.text.TextFormat;
	import starling.utils.Align;

	/**
	 * ...
	 * @author Vladimir Minkin
	 */
	public final class InfoPopup extends Popup
	{
		private static var instance:InfoPopup;
		public static function getInstance():InfoPopup { 
			if (instance == null) instance = new InfoPopup();
			return instance;
		}
		
		private const
			sf					:Number 	= Application.SCALEFACTOR
		,	SW					:uint 		= Application.SCREEN_WIDTH
		,	SH					:uint	 	= Application.SCREEN_HEIGHT

		,	TITLE_W				:uint 		= SW * 0.618
		,	TITLE_H				:uint 		= 75 * sf
		,	TITLE_FONT_COLR		:uint 		= Colors.BLACK_11
		
		,	TEXT_W				:uint 		= TITLE_W
		,	TEXT_OFFSET_Y		:uint 		= 128 * sf
		,	TEXT_FONT_NAME		:String 	= Fonts.LATO_THIN
		,	TEXT_FONT_SIZE		:uint 		= 18 * sf
		,	TEXT_FONT_COLR		:uint 		= Colors.BLACK_11
		,	TEXT_LEADING		:uint 		= 4 * sf
		
		,	SEPARATOR_W			:uint 		= TEXT_W * 1.1
		,	SEPARATOR_OFFSET	:int 		= (TEXT_W - SEPARATOR_W) * 0.5
		
		,	BACK_ALPHA			:Number 	= 0.98
		,	BACK_COLOR			:uint 		= Colors.WHITE_FA
		;

		private var 
			buttonClose		:Button
		;
		
		private const 
			_back			:Quad 		= new Quad(SW, SH, BACK_COLOR)
		,	_txtLayer		:Sprite 	= new Sprite()
		,	_txtTitle		:TextField 	= new TextField(TITLE_W, TITLE_H, "", null)
//			new TextFormat(Defaults.TITLE_FONT_NAME, Defaults.TITLE_FONT_SIZE * sf, TITLE_FONT_COLR))
//		,	_txtText		:TextField	= new TextField(TEXT_W, 1, "",
//			new TextFormat(TEXT_FONT_NAME, TEXT_FONT_SIZE, TEXT_FONT_COLR, Align.LEFT))
		;
		private var separator:Quad;
		public function InfoPopup() 
		{
			super( Popups.INFO );
			
			const BUTTONS : ButtonAssets = ButtonAssets.getInstance();
			const VCENTER:uint = SH * 0.50;
			
			_back.alpha = BACK_ALPHA;
			this.addChild(_back);
			
			_txtTitle.x = (SW - _txtTitle.width) * 0.5;
			_txtTitle.y = Defaults.TITLE_OFFSET_Y * sf;
			_txtTitle.batchable = true;
			_txtTitle.touchable = false;
			
//			_txtText.autoSize = TextFieldAutoSize.VERTICAL;
//			_txtText.x = _txtTitle.x;
//			_txtText.batchable = true;
//			_txtText.touchable = false;
//			_txtText.format.leading = 3 * sf;
			
//			_txtLayer.addChild(_txtText);
//			_txtLayer.addChild(_txtTitle);
//			this.addChild(_txtLayer);
			
//			separator = new Quad(SEPARATOR_W, sf, Colors.BLACK_44);
//			separator.x = _txtText.x + SEPARATOR_OFFSET;
//			separator.y = SH - 100 * sf;
//			this.addChild(separator);
			
			// Кнопка закрывает окно и передает массив отвеченных правильно вопросов (событие TAP_HAPPEND_OK)
			buttonClose 	= Asset(BUTTONS.close).clone;
			buttonClose.x 	= SW - buttonClose.width;
			buttonClose.y 	= 0;
			this.addChild(buttonClose);
		}
		
		// Данные формируются в комманде ShowInfoPopupCommand
		// здесь приходит объект с заголовком и описанием
		// { title: "" , text: "" };
		override public function prepare(data:Object):void {
//			_txtTitle.text = String(data.title);
//			_txtText.text = String(data.text);
//
//			_back.y = buttonClose.y + buttonClose.height * 0.5;
//			_back.x = buttonClose.x + buttonClose.width * 0.5;
//			_back.scaleX = 0;
//			_back.scaleY = 0;
//			_back.alpha = BACK_ALPHA;
//
//			_txtText.y = _txtTitle.y + TEXT_OFFSET_Y;
//
//			_txtLayer.alpha = 1;
//			_txtTitle.alpha = 0;
//			_txtText.alpha = 0;
//			buttonClose.alpha = 0;
//
//			separator.scaleX = 0;
//			separator.x = _txtText.x + TEXT_W * 0.5;
//
//			_txtTitle.y -= TITLE_H * 0.25;
		}
		
		//==================================================================================================
		override public function show():void {
		//==================================================================================================
//			var tween1:Tween = new Tween(_back, 0.4, Transitions.EASE_OUT);
//			var tween2:Tween = new Tween(_txtTitle, 0.8, Transitions.EASE_OUT);
//			var tween3:Tween = new Tween(_txtText, 0.5);
//			var tween4:Tween = new Tween(buttonClose, 0.5);
//			var tween5:Tween = new Tween(separator, 0.4, Transitions.EASE_OUT_BACK);
//
//			tween1.animate("scaleY", 1);
//			tween1.animate("scaleX", 1);
//			tween1.animate("x", 0);
//			tween1.animate("y", 0);
//
//			tween2.delay = 0.2;
//			tween2.fadeTo(1);
//			tween2.animate("y", _txtTitle.y + TITLE_H*0.25);
//
//			tween3.fadeTo(1);
//			tween4.fadeTo(1);
//
//			tween5.animate("x", _txtText.x + SEPARATOR_OFFSET);
//			tween5.animate("scaleX", 1);
//
//			tween1.nextTween = tween2;
//			tween2.nextTween = tween3;
//			tween3.nextTween = tween4;
//			tween4.nextTween = tween5;
//
//			tween5.onComplete = function():void {
//				Starling.juggler.purge();
//				instance.addEventListener(Event.TRIGGERED, HandleTriggerEvent);
//			}
//
//			Starling.juggler.add(tween1);
			this.addEventListener(Event.TRIGGERED, HandleTriggerEvent);
		}

		//==================================================================================================
		override public function hide(next:Function):void {
		//==================================================================================================
			this.removeEventListener(Event.TRIGGERED, HandleTriggerEvent);
			
			var tween0:Tween = new Tween(buttonClose, 0.2);
//			var tween1:Tween = new Tween(_txtLayer, 0.3);
			var tween2:Tween = new Tween(_back, 0.4, Transitions.EASE_OUT);
//			
			tween0.fadeTo(0);
//			tween1.fadeTo(0);
			tween2.delay = 0.25;
			tween2.fadeTo(0);
			
//			tween2.animate("scaleY", 0);
//			tween2.animate("scaleX", 0);
//			tween2.animate("x", buttonClose.x + buttonClose.width * 0.5);
//			tween2.animate("y", buttonClose.y + buttonClose.height * 0.5);
			
			tween0.nextTween = tween2;
//			tween1.nextTween = tween2;
			tween2.onComplete = next;
			tween2.onCompleteArgs = [this.name];
			Starling.juggler.add(tween0);
//			Starling.juggler.tween(separator, 0.3, { scaleX:0, x:(separator.x + SEPARATOR_W*0.5), transition:Transitions.EASE_IN });
		}
		
		//==================================================================================================
		private function HandleTriggerEvent(e:Event):void {
		//==================================================================================================
			e.stopImmediatePropagation();
			switch (DisplayObject(e.target)) 
			{
				case buttonClose:
					this.dispatchEventWith(PopupEvents.TAP_HAPPEND_CLOSE);
					break;
			}
		}
	}
}
