package app.view.components.popups.mails
{
	import flash.geom.Point;
	
	import app.view.components.popups.MailsPopup;
	
	import consts.Colors;

	import nest.entities.application.Application;

	import starling.animation.Transitions;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.utils.Align;
	
	public final class MailMessage extends Sprite
	{
		public static var 
			WIDTH			: uint
		,	SIZE_TITLE		: uint
		, 	SIZE_MESSAGE	: uint
		
		,	EVENT_MAIL_READED	: String = "event_mail_readed"
		,	EVENT_MAIL_TOUCHED	: String = "event_mail_touched"
		;
		
		private static const MESSAGE_MAX_LENGTH:uint = 250;
		
		private static const COLOR_UNREADED:uint = 250;
		private static const COLOR_TEXT_READED:uint = Colors.GREY_99;
		private static const COLOR_BACK_READED:uint = Colors.WHITE_F1;
		
		private const _background:Quad = new Quad(WIDTH, 1, Colors.WHITE_FD);
		private var 
			_closeBtn		: Button
		,	_readedIcon		: Image
		,	_titleTF		: TextField
		,	_messageTF		: TextField
		,	_message		: String
		
		,	_readed			: Boolean
		;
		
		private var position:Point = new Point();
		private var _index:uint = 0;

		
		public var id:uint = 0;
		/**
		 * Параметр который говорит какой элемент массива удалять
		 */
		public var inarray:uint = 0;
		
		public var isSet:Boolean = false;
		public var isExpand:Boolean = false;
		public var isAnimated:Boolean = false;
		public var isMayExpand:Boolean = false;
		
		public function get index():uint
		{
			return _index;
		}

		private const titleOffset:uint = SIZE_TITLE * 0.618;
		private const messageXOffset:uint = SIZE_MESSAGE * 1.618;
		private const messageYOffset:uint = SIZE_MESSAGE * 0.618;
		
		public function get closeBtn():Button { return _closeBtn; }

		public function MailMessage(index:uint) {
			super();
			
			this._index = index;
		}
		
		private var touch:Touch;
		private var _touchPos:int;
		private function HandleTouchEnd(e:TouchEvent):void {
			touch = e.getTouch(this, TouchPhase.ENDED);
			if(touch && e.target != closeBtn && isAnimated == false) {
				_touchPos = touch.globalY;
				if(_touchPos > this.y && _touchPos < (this.y + _background.height)) {
					if(isMayExpand) {
						if(isExpand) collapse();
						else {
							if(MailsPopup(this.parent).isNavPossible)
							expand();
						}
					} else {
						if(!readed) {
							SetMessageReadedIfAvailable();
							this.dispatchEventWith( EVENT_MAIL_READED );
						}
					}
				}
			}
		}
		
		public function reset():void {
			_closeBtn.y = _closeBtn.height * 0.618;
			_closeBtn.x = WIDTH - _closeBtn.width * 1.618;
			_closeBtn.alpha = 1;
			
			_titleTF.y = _titleTF.x = titleOffset;
			_titleTF.alpha = 1;
			
			_messageTF.x = messageXOffset;
			_messageTF.alpha = 1;
			_messageTF.y = _titleTF.y + _titleTF.height + messageYOffset;
			
			_background.width = WIDTH;
			_background.x = 0;
			_background.y = 0;
			
			isAnimated = false;
		}
		
		/**
		 * Вызывается в двух случаях
		 * 1. После окончания анимации свертывания, если _readed = false;
		 */
		public function set readed(value:Boolean):void {
			this._readed = value;
			if(value === true) {
				_readedIcon.x = _titleTF.x + _titleTF.width + _closeBtn.height * 0.618;
				_readedIcon.y = _titleTF.y + (_titleTF.height - _readedIcon.height)*0.5;
				this.addChild(_readedIcon);
			} else {
				_readedIcon.removeFromParent();
			}
		}
		
		public function get readed():Boolean {
			return this._readed;
		}
		
		
		public function expand():void {
			const sw:uint = Application.SCREEN_WIDTH;
			const sh:uint = Application.SCREEN_HEIGHT;
			
			isExpand = !isExpand;
			isMayExpand = false;
			isAnimated = true;
			
			this.dispatchEventWith(EVENT_MAIL_TOUCHED, true, true);
			
			position.x = this.x;
			position.y = this.y;
			
			_readedIcon.removeFromParent();
			
			_titleTF	.alpha = 0;
			_messageTF	.alpha = 0;
			_closeBtn	.alpha = 0;
			
			_messageTF.text = _message;
			
			this.parent.setChildIndex(this, this.parent.numChildren);
			_background.removeEventListener(TouchEvent.TOUCH, HandleTouchEnd);
			
			Starling.juggler.tween(_background, 0.3, 
				{ x : -position.x, width: sw, transition:Transitions.EASE_OUT,
				onComplete: function():void {
					Starling.juggler.tween(_background, 0.3, 
					{ y : -position.y, height: sh, transition:Transitions.EASE_OUT,
					onComplete: function():void {
						_titleTF.format.horizontalAlign = Align.CENTER;
						_titleTF.x = -position.x + ( sw - _titleTF.width ) * 0.5;
						_titleTF.y = -position.y + 64 * Application.SCALEFACTOR;
						_messageTF.y = -position.y + (sh - _messageTF.height) * 0.5 - messageYOffset * 2;
						
						_closeBtn.x = -position.x + sw - _closeBtn.width * 1.618;;
						_closeBtn.y = -position.y + _closeBtn.height * 0.618;;
						
						Starling.juggler.tween(_background, 0.1, {color:  Colors.WHITE_FD});
						Starling.juggler.tween(_titleTF, 0.3, {alpha: 1});
						Starling.juggler.tween(_messageTF, 0.3, { alpha: 1, 
						onComplete:function():void {
							isMayExpand = true;
							isAnimated = false;
							_closeBtn.addEventListener(Event.TRIGGERED, HandleCloseTriggered);
							Starling.juggler.tween(_closeBtn, 0.3, {alpha: 1});
						}});
					}});
				}});
			
			this.dispatchEventWith( EVENT_MAIL_READED );
		}
		
		private function HandleCloseTriggered(e:Event):void
		{
			_closeBtn.removeEventListener(Event.TRIGGERED, HandleCloseTriggered);
			e.stopImmediatePropagation();
			collapse();
		}
		
		public function collapse():void {
			isMayExpand = false;
			isExpand = !isExpand;
			isAnimated = true;
			_closeBtn.alpha = 0;
			
			Starling.juggler.tween(_titleTF, 0.25, {alpha: 0});
			Starling.juggler.tween(_messageTF, 0.25, { alpha: 0 });
			Starling.juggler.tween(_background, 0.3, 
				{ x : 0, width: WIDTH, transition:Transitions.EASE_OUT,
				onComplete: function():void {
					_titleTF.format.horizontalAlign = Align.LEFT;
					_titleTF.y = _titleTF.x = titleOffset;
					_messageTF.text = MakeShortMessage(_message);
					_messageTF.x = messageXOffset;
					_messageTF.y = _titleTF.y + _titleTF.height + messageYOffset;
					_closeBtn.x = WIDTH - _closeBtn.width * 1.618;
					_closeBtn.y = _closeBtn.height * 0.618;
					Starling.juggler.tween(_background, 0.3, 
						{ y : 0, height: (_messageTF.y + _messageTF.height + _titleTF.y), transition:Transitions.EASE_OUT,
						onComplete:function():void{
							if(!readed) SetMessageReadedIfAvailable();
							Starling.juggler.tween(_titleTF, 0.3, {alpha: 1});
							Starling.juggler.tween(_messageTF, 0.3, { alpha: 1 });
							Starling.juggler.tween(_closeBtn, 0.3, { alpha: 1, 
								onComplete:function():void {
									isMayExpand = true;
									isAnimated = false;
									if(_readed && _readedIcon.parent == null)_background.parent.addChild(_readedIcon);
									_background.addEventListener(TouchEvent.TOUCH, HandleTouchEnd);
									_background.parent.dispatchEventWith(EVENT_MAIL_TOUCHED, true, false);
								}});
						}});
				}});
		}
		
		public function set message(value:String) : void {
			const notHasTouchListener:Boolean = !_background.hasEventListener(TouchEvent.TOUCH);
			const isMessageTooLong:Boolean = value.length > MESSAGE_MAX_LENGTH;
			
			_message = value;
			if(isMessageTooLong) value = MakeShortMessage(value);
			if(notHasTouchListener) _background.addEventListener(TouchEvent.TOUCH, HandleTouchEnd);
			
			isMayExpand = true;
			SetMessageTextAndAdjustBackground(value);
		}
		
		public function set title(value:String) : void {
			_titleTF.text = value;
		}
		
		private function SetMessageReadedIfAvailable():void
		{
			readed = true;
		}
		
		private function SetMessageTextAndAdjustBackground(value:String):void {
			_messageTF.text = value;
			_background.height = _messageTF.y + _messageTF.height + _titleTF.y;
		}
		
		private function MakeShortMessage(value:String):String {
			const result:String = value.substr(0, MESSAGE_MAX_LENGTH);
			const arrayFromDot:Array = result.split(".");
			arrayFromDot[arrayFromDot.length - 1] = "..";
			return arrayFromDot.join(".");
		}
		
	}
}