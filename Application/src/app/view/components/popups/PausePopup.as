package app.view.components.popups 
{
	import app.model.data.popup.ConfirmPopupData;
	import app.model.data.popup.PausePopupData;
	
	import consts.Colors;
	import consts.Confirms;
	import consts.Fonts;
	import consts.Popups;
import consts.assets.ButtonAssets;

import nest.entities.application.Application;
	import nest.entities.assets.Asset;
	import nest.entities.popup.Popup;
	import nest.entities.popup.PopupEvents;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.utils.Align;

	/**
	 * ...
	 * @author Vladimir Minkin
	 */
	public final class PausePopup extends Popup
	{
		private static var instance:PausePopup;
		
		static private const 
			CMD_RESET	: uint = 0
		,	CMD_QUIT	: uint = 1
		,	CMD_NAV		: uint = 2
		;
			
		private const
			sf					:Number 	= Application.SCALEFACTOR
		,	SW					:uint 		= Application.SCREEN_WIDTH
		,	SH					:uint	 	= Application.SCREEN_HEIGHT

		,	BTN_OFFSET_Y_CNTR	:uint 		= 144 * sf
		,	STT_OFFSET_Y_CENTER	:int 		= -24 * sf
		,	TITLE_OFFSET_Y		:int 		= 96 * sf
		,	STT_OFFSET_X		:int 		= 16 * sf
		
		,	NAV_BTN_MARGIN		:int 		= 12 * sf
		
		,	TITLE_W				:uint 		= 250 * sf
		,	TITLE_H				:uint 		= 36 * sf
		,	TITLE_FONT_NAME		:String 	= Fonts.ROBOTO_BOLD
		,	TITLE_FONT_SIZE		:uint 		= 36 * sf
		,	TITLE_FONT_COLR		:uint 		= Colors.WHITE_FC
		
		,	STATS_WIDTH			:uint	 	= SW * 0.5
		,	STATS_FONT_NAME		:String 	= Fonts.ROBOTO_LIGHT
		,	STATS_FONT_SIZE		:uint 		= 20 * sf
		,	STATS_FONT_COLR		:uint 		= Colors.WHITE_FC
		
		,	BACK_ALPHA			:Number 	= 0.8
		,	BACK_COLOR			:uint 		= Colors.BLACK_00
		;

		private var 
			buttonQuit		:Button
		,	buttonReset		:Button
		,	buttonClose		:Button
		,	buttonNext		:Button
		,	buttonPrev		:Button
		;
		
		private const _background		: Quad = new Quad(SW, SH, BACK_COLOR);
		private const _textLayer		: Sprite = new Sprite();
		
		private const _txtTitle			: TextField = new TextField(TITLE_W, TITLE_H, "", new TextFormat(TITLE_FONT_NAME, TITLE_FONT_SIZE, TITLE_FONT_COLR));
		private const _txtStats			: TextField = new TextField(STATS_WIDTH, 1, "", new TextFormat(STATS_FONT_NAME, STATS_FONT_SIZE, STATS_FONT_COLR, Align.LEFT));
		
		public function PausePopup() 
		{
			super( Popups.PAUSE );

			const BUTTONS : ButtonAssets = ButtonAssets.getInstance();
			
			_background.alpha = BACK_ALPHA;
			this.addChild(_background);
			
			const HCENTER:uint = SW * 0.50;
			const VCENTER:uint = SH * 0.50;
			
			_txtTitle.x = HCENTER - _txtTitle.width * 0.5;
			_txtTitle.y = TITLE_OFFSET_Y;
			_txtTitle.batchable = true;
			_txtTitle.touchable = false;
			
			_txtStats.autoSize = TextFieldAutoSize.VERTICAL;
			_txtStats.touchable = false;
			_txtStats.batchable = true;
			_txtStats.format.leading = 12 * sf;
			_txtStats.x = (SW - STATS_WIDTH) * 0.75 + STT_OFFSET_X;
			
			_textLayer.addChild(_txtTitle);
			_textLayer.addChild(_txtStats);
			this.addChild(_textLayer);

			// Кнопка закрывает окно и передает массив отвеченных правильно вопросов (событие TAP_HAPPEND_OK)
			buttonClose 	= Asset(BUTTONS.close).clone;
			buttonClose.x 	= HCENTER + buttonClose.width * 2;
			this.addChild(buttonClose);
			
			// Кнопка закрывает окно, ничего не передает (событие TAP_HAPPEND_CLOSE)
			buttonReset 	= Asset(BUTTONS.reload).clone;
			buttonReset.x 	= HCENTER - buttonReset.width * 0.5;
			this.addChild(buttonReset);
			
			// Кнопки навигации по вопросам
			buttonQuit 		= Asset(BUTTONS.back).clone;
			buttonQuit.x 	= HCENTER - buttonQuit.width * 3;
			this.addChild(buttonQuit);
			
			const btnPosY:uint = VCENTER + BTN_OFFSET_Y_CNTR;
			buttonClose.y 	= btnPosY;
			buttonReset.y 	= btnPosY;
			buttonQuit.y 	= btnPosY;
			
			const btnTexture:Texture = Texture.fromColor(144 * sf, 96 * sf, 0xf1f1f1, 0);
			
			const btnTextFormat:TextFormat = new TextFormat(
				Fonts.ROBOTO_CONDENSED, 
				18 * sf, 
				Colors.GREY_CC
			);
			
			buttonNext 		= new Button(btnTexture);
			buttonNext.x 	= SW - buttonNext.width - NAV_BTN_MARGIN;
			buttonNext.y 	= SH - buttonNext.height - NAV_BTN_MARGIN;
			buttonNext.textFormat = btnTextFormat;
				
			buttonPrev 		= new Button(btnTexture);
			buttonPrev.x 	= NAV_BTN_MARGIN;
			buttonPrev.y 	= buttonNext.y;
			buttonPrev.textFormat = btnTextFormat;

			/**
			 * ANDROID ONLY
			 * Этот popup не будет закрываться при нажатии на кнопку назад
			 */
			this.backRemovable = false;
			
			this.addEventListener(Event.ADDED_TO_STAGE, Handle_AddToStage);
		}
		
		public static function getInstance():PausePopup { 
			if (instance == null) instance = new PausePopup();
			return instance;
		}
		
		//==================================================================================================
		override public function localize(data:XMLList):void {
		//==================================================================================================
			_txtTitle.text = data.title;
			buttonNext.text = data.next;
			buttonPrev.text = data.prev;
			super.localize(data);
		}
		
		// Данные формируются в комманде ShowPausePopupCommand
		// { steps: levelVO.steps, completed: levelVO.completed };
		override public function prepare(input:Object):void {
			const data:PausePopupData = PausePopupData(input);
			
			var statistics			: String = data.statistics;
			
			const isCompleted		: Boolean = data.isCompleted;
			const isNextAvailable	: Boolean = data.isNextAvailable;
			const isPrevAvailable	: Boolean = data.isPrevAvailable;
			const titleY			: uint = TITLE_OFFSET_Y + TITLE_H;
			
			// Показываем кнопку "Следующий пазл"
			if(isNextAvailable) this.addChild(buttonNext); 
			else if(buttonNext.parent) buttonNext.removeFromParent();
			
			// Показываем кнопку "Предыдущий пазл"
			if(isPrevAvailable) this.addChild(buttonPrev); 
			else if(buttonPrev.parent) buttonPrev.removeFromParent();
			
			if(statistics.indexOf("{cgt}") >= 0) statistics = statistics.replace("{cgt}", _locale.playtime);
			if(statistics.indexOf("{agt}") >= 0) statistics = statistics.replace("{agt}", _locale.gametime);
			if(statistics.indexOf("{prg}") >= 0) statistics = statistics.replace("{prg}", _locale.progress);
			if(statistics.indexOf("{stp}") >= 0) statistics = statistics.replace("{stp}", _locale.steps);
			
			_txtTitle.text = isCompleted ? _locale.complete : _locale.title;
			_txtStats.text = statistics;
			_txtStats.y = titleY + (SH * 0.5 + BTN_OFFSET_Y_CNTR - titleY - _txtStats.height) * 0.5;
		}
		
		override public function show():void {
			this.alpha = 0;
			Starling.juggler.removeTweens(this);
			Starling.juggler.tween(this, 0.35, { alpha:1, transition: Transitions.EASE_OUT
//				, onComplete:function():void{ instance.backRemovable = true; } 
			});
		}
		
		override public function hide(next:Function):void {
			this.backRemovable = false;
			Starling.juggler.removeTweens(this);
			Starling.juggler.tween(this, 0.3, 
			{ alpha:0, transition: Transitions.LINEAR, onComplete:next, onCompleteArgs:[instance.name] });
		}
		
		//==================================================================================================
		private function Handle_AddToStage(e:Event):void {
		//==================================================================================================
			this.removeEventListener(Event.ADDED_TO_STAGE, Handle_AddToStage);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, Handle_RemoveFromStage);
			this.addEventListener(Event.TRIGGERED, HandleTriggerEvent);
		}
		
		//==================================================================================================
		private function Handle_RemoveFromStage(e:Event):void {
		//==================================================================================================
			this.removeEventListener(Event.REMOVED_FROM_STAGE, Handle_RemoveFromStage);
			this.removeEventListener(Event.TRIGGERED, HandleTriggerEvent);
			
			this.addEventListener(Event.ADDED_TO_STAGE, Handle_AddToStage);
		}

		//==================================================================================================
		private function HandleTriggerEvent(e:Event):void {
		//==================================================================================================
			e.stopImmediatePropagation();
			const target:DisplayObject = DisplayObject(e.target);
			switch (target) 
			{
				case buttonClose:
					this.dispatchEventWith(PopupEvents.TAP_HAPPEND_CLOSE);
					break;
//				case buttonReset:
//					this.dispatchEventWith( PopupEvents.SHOW_CONFIRM_POPUP, false,
//						new ConfirmPopupData( Confirms.RESET,
//							function(result):void {
//								if(result) {
//									_commandID = CMD_RESET;
//									instance.dispatchEventWith(PopupEvents.COMMAND_FROM_POPUP);
//									instance.dispatchEventWith(PopupEvents.TAP_HAPPEND_CLOSE);
//								}
//							}
//						)
//					);
//					break;
				case buttonPrev:
				case buttonNext:
					_commandID = CMD_NAV;
					this.dispatchEventWith(PopupEvents.COMMAND_FROM_POPUP, false, target == buttonPrev ? -1 : 1);
					this.dispatchEventWith(PopupEvents.TAP_HAPPEND_CLOSE);
					break;
				case buttonQuit:
					_commandID = CMD_QUIT;
					this.dispatchEventWith(PopupEvents.COMMAND_FROM_POPUP);
					break;
			}
		}
	}
}
