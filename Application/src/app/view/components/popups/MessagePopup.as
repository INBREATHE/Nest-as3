package app.view.components.popups 
{
	import flash.geom.Point;
	
	import app.model.data.popup.MessagePopupData;
	
	import consts.Colors;
	import consts.Fonts;
	import consts.Popups;
	
	import nest.entities.application.Application;
	import nest.entities.popup.Popup;
	import nest.entities.popup.PopupEvents;
	
	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Canvas;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.text.TextFormat;
	import starling.utils.Align;

	/**
	 * ...
	 * @author Vladimir Minkin
	 */
	public final class MessagePopup extends Popup
	{
		private static var instance:MessagePopup;
		public static function getInstance():MessagePopup { 
			if (instance == null) instance = new MessagePopup();
			return instance;
		}
		
		private const
			sf			:Number 	= Application.SCALEFACTOR

		,	SW			:uint 		= Application.SCREEN_WIDTH
		,	SH			:uint 		= Application.SCREEN_HEIGHT
		
		,	TEXT_W				:uint 		= 350 * sf
		,	TEXT_FONT_NAME		:String 	= Fonts.ROBOTO_REGULAR
		,	TEXT_FONT_SIZE		:uint 		= 12 * sf
		,	TEXT_FONT_COLR		:uint 		= Colors.BLACK_11
		
		,	TEXT_MARGIN			:uint 		= 16 * sf
		,	TEXT_BACK_COLOR		:uint 		= Colors.WHITE_F1
		
		,	BACK_ALPHA			:Number 	= 0.7
		,	BACK_COLOR			:uint 		= Colors.BLACK_23
		;
		
		private const 
			_shape			:Canvas		= new Canvas()
		,	_txtText		:TextField 	= new TextField(TEXT_W, 1, "", new TextFormat(TEXT_FONT_NAME, TEXT_FONT_SIZE, TEXT_FONT_COLR, Align.LEFT))
		
		public function MessagePopup() 
		{
			super( Popups.MESSAGE );
			
			this.prioritet = 1000;
			this.addChild(_shape);
			
			_txtText.autoSize = TextFieldAutoSize.VERTICAL;
			_txtText.format.leading = 3 * sf;
			_txtText.touchable = false;
			_txtText.batchable = true;
			this.addChild(_txtText);
			
			this.addEventListener(TouchEvent.TOUCH, Handle_Touch);
		}
		
		private function Handle_Touch(e:TouchEvent):void {
			const touch:Touch = e.getTouch(this, TouchPhase.ENDED);
			if(touch) this.dispatchEventWith( PopupEvents.TAP_HAPPEND_CLOSE );
		}
		
		//==================================================================================================
		override public function show():void { 
		//==================================================================================================	
			Starling.juggler.tween(this, 0.35, { alpha:1, transition:Transitions.LINEAR });
		}
		
		//==================================================================================================	
		override public function hide(next:Function):void { 
		//==================================================================================================	
			Starling.juggler.tween(this, 0.35, {alpha:0, transition:Transitions.LINEAR, onComplete:function():void{
				next(instance.name);
			}});
		}
		
		override public function prepare(input:Object):void {
			
			const data		:MessagePopupData = input as MessagePopupData;
			const position	:Point = data.position;
			
			var xPos:uint = position.x;
			var yPos:uint = position.y;
			
			_txtText.text = data.text;
			
			const textHeight:uint = _txtText.height;
			const backW:uint = TEXT_W + TEXT_MARGIN * 1.5;
			const backH:uint = _txtText.height + TEXT_MARGIN * 2;
			
			if(xPos + backW >= SW) xPos -= TEXT_MARGIN * 1.25;
			else xPos += TEXT_MARGIN * 1.25;
			
			if(yPos - textHeight > 0) yPos -= _txtText.height + TEXT_MARGIN * 1.5;
			else yPos += TEXT_MARGIN * 2.5;
			
			const backX:uint = xPos - TEXT_MARGIN;
			const backY:uint = yPos - TEXT_MARGIN;
			
			_txtText.x = xPos;
			_txtText.y = yPos;
			
			_shape.clear();
			_shape.beginFill(BACK_COLOR, BACK_ALPHA);
			_shape.drawRectangle(0, 0, SW, SH);
			_shape.endFill();			
			
			_shape.beginFill(TEXT_BACK_COLOR);
			_shape.drawRectangle(backX,backY,backW,backH);
			_shape.endFill();	
			
			this.alpha = 0;
		}
	}
}
