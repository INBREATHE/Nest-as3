package app.view.components.popups 
{
	import app.model.data.event.MailMessageData;
	import app.model.vo.MailVO;
	import app.view.components.popups.mails.MailMessage;
	
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
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.text.TextFormat;
	
	/**
	 * ...
	 * @author Vladimir Minkin
	 */
	public final class MailsPopup extends Popup
	{
		private static var instance:MailsPopup;
		
		private const 
			sf					:Number 	= Application.SCALEFACTOR
		,	SW					:uint 		= Application.SCREEN_WIDTH
		,	SH					:uint	 	= Application.SCREEN_HEIGHT
		
		,	TITLE_W				:uint 		= SW * 0.618
		
		,	COUNT_W				:uint 		= 100 * sf
		,	COUNT_H				:uint 		= 24 * sf
		,	COUNT_OFFSET_Y		:uint 		= 56 * sf
		,	COUNT_FONT_NAME		:String 	= Fonts.LATO_REGULAR
		,	COUNT_FONT_SIZE		:uint 		= 16 * sf
		,	COUNT_FONT_COLR		:uint 		= Colors.GREY_AA
		
		,	MESSAGE_WIDTH		:uint 		= SW * 0.618
		,	MESSAGE_HEIGHT		:uint 		= 150 * sf
		,	MESSAGE_ANIM_TIME	:Number		= 0.35
		,	MESSAGE_ANIM_OFFSET	:uint 		= 25 * sf
		,	MESSAGE_DELTA_Y		:uint		= 28 * sf
		
		,	SWIPE_DELTA_Y		:uint		= 75 * sf
		
		,	MESSAGE_FIRST_Y		:uint		= 2 * Defaults.TITLE_OFFSET_Y * sf + Defaults.TITLE_HEIGHT * sf
		
		;

		static private const BACK_ALPHA:Number = 1;
		static private const BACK_COLOR:Number = Colors.BLACK_11;

		private const
			_txtTitle		: TextField 	= new TextField(TITLE_W, Defaults.TITLE_HEIGHT * sf, "", new TextFormat(Defaults.TITLE_FONT_NAME, Defaults.TITLE_FONT_SIZE * sf, Defaults.TITLE_FONT_COLR))
		,	_txtCounter		: TextField 	= new TextField(COUNT_W, COUNT_H, "", new TextFormat(COUNT_FONT_NAME, COUNT_FONT_SIZE, COUNT_FONT_COLR))
		;
		
		private var 
			_btnClose		: Button
		,	_btnNext			: Button
		,	_btnPrev			: Button
		,	mail1			: MailMessage
		,	mail2			: MailMessage
		,	mail3			: MailMessage
		, 	mails			: Array
		,	mailMin			: int
		,	mailMax			: int
		
		,	BUTTON_NAV_X	:uint
		;	
			
		private const background:Quad = new Quad(SW, SH, BACK_COLOR);

		private var mailsCount:uint;
		private var isTriggable:Boolean = true;
		
		public var isNavPossible:Boolean = true;

		public function MailsPopup() 
		{
			super( Popups.MAILS );
			
			const BUTTONS : ButtonAssets = ButtonAssets.getInstance();

			background.alpha = BACK_ALPHA;
			this.addChild(background);

			_txtCounter.x = (SW - _txtCounter.width) * 0.5;
			_txtCounter.text = "";
			_txtCounter.y = SH - COUNT_OFFSET_Y;
			_txtCounter.batchable = true;
			_txtCounter.touchable = false;
			this.addChild(_txtCounter);

			_txtTitle.x = (SW - _txtTitle.width) * 0.5;
			_txtTitle.y = Defaults.TITLE_OFFSET_Y * sf;
			_txtTitle.batchable = true;
			_txtTitle.touchable = false;
			this.addChild(_txtTitle);

			_btnClose 	= Asset(BUTTONS.close).clone;
			_btnClose.x 	= SW - _btnClose.width;
			_btnClose.y 	= 0;
			this.addChild(_btnClose);
			
			MailMessage.WIDTH = MESSAGE_WIDTH;
			MailMessage.SIZE_TITLE = 24 * sf;
			MailMessage.SIZE_MESSAGE = 16 * sf;
			
			mail1 = new MailMessage(1);
			mail2 = new MailMessage(2);
			mail3 = new MailMessage(3);
			
			const mailXPos:uint = SW * 0.382 * 0.5;
			mail1.x = mailXPos;
			mail2.x = mailXPos;
			mail3.x = mailXPos;
			
			mail1.y = MESSAGE_FIRST_Y;
			
			mail1.addEventListener( MailMessage.EVENT_MAIL_READED, HandleMailReaded );
			mail2.addEventListener( MailMessage.EVENT_MAIL_READED, HandleMailReaded );
			mail3.addEventListener( MailMessage.EVENT_MAIL_READED, HandleMailReaded );
			
			_btnPrev = BUTTONS.arrow.clone as Button;
			_btnPrev.rotation = Math.PI * 0.5;
			_btnNext = BUTTONS.arrow.clone as Button;
			_btnNext.rotation = -Math.PI * 0.5;
			
			const btnNavYPos:uint = SH * 0.5;
			
			_btnPrev.y = btnNavYPos - _btnPrev.height;
			_btnNext.y = btnNavYPos + _btnNext.height;
			
			BUTTON_NAV_X = mailXPos * 1.5 + MESSAGE_WIDTH;		
			
			this.addChild(_btnPrev);
			this.addChild(_btnNext);
			this.addEventListener(MailMessage.EVENT_MAIL_TOUCHED, HandleMailMessageTouchedEvent);
			this.addEventListener(TouchEvent.TOUCH, HandleTouchEvent);
		}
		
		private function HandleMailMessageTouchedEvent(e:Event, isStartOrEnd:Boolean):void
		{
			isNavPossible = !isStartOrEnd;
			trace("\n isNavPossible", isNavPossible);
		}
		
		private var _touch:Touch;	
		private var _touchStartPosition:int;
		private var _touchEndPosition:int;
		private var _swipeDeltaY:int;
		private function HandleTouchEvent(e:TouchEvent):void
		{
			if(isNavPossible) {
				_touch = e.getTouch(this);
				if(_touch) {
					switch(_touch.phase)
					{
						case TouchPhase.BEGAN:
						{
							_touchStartPosition = _touch.globalY;
						}
							
						case TouchPhase.ENDED: 
						{
							_touchEndPosition = _touch.globalY;
							_swipeDeltaY = _touchEndPosition - _touchStartPosition;
							if(_swipeDeltaY > SWIPE_DELTA_Y) {
								e.stopPropagation();
								e.stopImmediatePropagation();
								trace("SWIPE HAPPEND - PREV");
								if(_btnPrev.enabled) NavigatePrev();
							} else if(_swipeDeltaY < -SWIPE_DELTA_Y) {
								e.stopPropagation();
								e.stopImmediatePropagation();
								trace("SWIPE HAPPEND - NEXT");
								if(_btnNext.enabled) NavigateNext();
							}
						}
					}
				}
			}
		}
		
		public static function getInstance():MailsPopup { 
			if (instance == null) instance = new MailsPopup();
			return instance;
		}
		
		//==================================================================================================
		override public function localize(data:XMLList):void {
		//==================================================================================================
//			_txtTitle.text = data.@title;
		}
		
		override public function prepare(data:Object):void {
			mails = data as Array;
			
			mailsCount = mails.length;
			
			_btnPrev.enabled = false;
			_btnNext.enabled = mailsCount > 2 ? true : false;
			
			mailMin = 0;
			
			trace("MAILS:", mailsCount, JSON.stringify(mails));
			
			if(mailsCount >= 1) {
				SetupMailMessage( mail1, mails[mailsCount - 1]);
			} else mail1.isSet = false;
			
			if(mailsCount >= 2) {
				SetupMailMessage( mail2, mails[mailsCount - 2]);
				
				mail2.y = SetNextMailYPosition(mail1);
			} else mail2.isSet = false;
			
			if(mailsCount >= 3) {
				SetupMailMessage( mail3, mails[mailsCount - 3]);
				mail3.y = SetNextMailYPosition(mail2);
				
				mailMax = 2;
			} else mail3.isSet = false;
			
			CheckMailCount();
			AdjustElementsBeforeShow();
		}
		
		//==================================================================================================
		private function AdjustElementsBeforeShow():void {
		//==================================================================================================
			background.y = _btnClose.height * 0.5;
			background.x = _btnClose.width * 0.5;
			background.scaleX = 0;
			background.scaleY = 0;
			background.alpha = BACK_ALPHA;
			
			_btnClose.alpha = 0;
//			_txtCounter.alpha = 0;
			
			mail1.y = MESSAGE_FIRST_Y;
			
			if(mail1.isSet) {
				mail1.y += MESSAGE_ANIM_OFFSET;
				mail1.alpha = 0;
			}
			
			if(mail2.isSet) {
				mail2.y += MESSAGE_ANIM_OFFSET;
				mail2.alpha = 0;
			}
			
			if(mail3.isSet) {
				mail3.y += MESSAGE_ANIM_OFFSET;
				mail3.alpha = 0;
			}
			
			_btnPrev.alpha = 1;
			_btnNext.alpha = 1;
//			_txtTitle.alpha = 0;
//			_txtTitle.y -= _txtTitle.height * 0.25;
			
			if(mailsCount > 3) {
				isNavPossible = true;
				_btnPrev.x = SW + _btnPrev.width;
				_btnNext.x = SW;
				this.addChild(_btnPrev);
				this.addChild(_btnNext);
			} else {
				_btnPrev.removeFromParent();
				_btnNext.removeFromParent();
			}
		}
		
		//==================================================================================================
		override public function show():void {
		//==================================================================================================
			var tween1:Tween = new Tween( background, 0.4, Transitions.EASE_OUT );
//			var tween2:Tween = new Tween( _txtTitle, 0.7 );
			var tween4:Tween = new Tween( _btnClose, 0.3 );
			
			tween1.animate("scaleY", 1);
			tween1.animate("scaleX", 1);
			tween1.animate("x", 0);
			tween1.animate("y", 0);
			
//			tween2.delay = 0.3;
//			tween2.fadeTo(1);
//			tween2.animate("y", _txtTitle.y + _txtTitle.height*0.25);
//			tween2.onComplete  = function():void {
//				if(mail1.isSet) Starling.juggler.tween(mail1, MESSAGE_ANIM_TIME, { alpha:1, y:mail1.y - MESSAGE_ANIM_OFFSET })
//				if(mail2.isSet) Starling.juggler.tween(mail2, MESSAGE_ANIM_TIME, { alpha:1, y:mail2.y - MESSAGE_ANIM_OFFSET, delay:MESSAGE_ANIM_TIME  })
//				if(mail3.isSet) Starling.juggler.tween(mail3, MESSAGE_ANIM_TIME, { alpha:1, y:mail3.y - MESSAGE_ANIM_OFFSET, delay:MESSAGE_ANIM_TIME * 2  })
//			}
				
//			tween4.delay = 1.2;
//			tween4.fadeTo(1);
//			tween4.onComplete = function():void {
//				MailsPopup.instance.addEventListener(Event.TRIGGERED, HandleTriggerEvent);
//				Starling.juggler.tween(_txtCounter, 0.3, { alpha:1 })
//			}
			
//			tween1.nextTween = tween2;
//			tween2.nextTween = tween4;
			
			Starling.juggler.purge();
			Starling.juggler.add(tween1);
			
			if(mailsCount > 3) {
				Starling.juggler.tween(_btnPrev, 1, {delay: 2, transition: Transitions.EASE_OUT, 
					x: BUTTON_NAV_X + _btnPrev.width*0.5});
				Starling.juggler.tween(_btnNext, 1, {delay: 2, transition: Transitions.EASE_OUT,
					x: BUTTON_NAV_X - _btnNext.width*0.5});
			}
		}	
		
		//==================================================================================================
		override public function hide(next:Function):void {
		//==================================================================================================
			this.removeEventListener(Event.TRIGGERED, HandleTriggerEvent);
			
//			var tween1:Tween = new Tween(background, 0.4);
//			var tween2:Tween = new Tween(_txtTitle, 0.3);
//			var tween4:Tween = new Tween(_btnClose, 0.2);
//
//			tween1.fadeTo(0);
//			tween2.fadeTo(0);
//			tween4.fadeTo(0);
//
//			tween4.nextTween = tween2;
//			tween2.nextTween = tween1;
//
//			tween1.onComplete = next;
//			tween1.onCompleteArgs = [instance.name];
//			tween1.delay = 0.25;
//
//			Starling.juggler.purge();
//			Starling.juggler.add(tween4);
//
//			Starling.juggler.tween(_txtCounter, 0.2, { alpha:0 })
//			if(mail1.isSet) Starling.juggler.tween(mail1, 0.3, {alpha:0});
//			if(mail2.isSet) Starling.juggler.tween(mail2, 0.3, {alpha:0});
//			if(mail3.isSet) Starling.juggler.tween(mail3, 0.3, {alpha:0});
//
//			Starling.juggler.tween(_btnNext, 0.3, {alpha:0, delay: 0.2});
//			Starling.juggler.tween(_btnPrev, 0.3, {alpha:0, delay: 0.2});
//
//			mails = null;
		}
			
		//==================================================================================================
		private function HandleMailReaded(e:Event):void {
		//==================================================================================================
			e.stopImmediatePropagation();
			trace("HandleMailExpand");
			const target:MailMessage = e.currentTarget as MailMessage;
			const mailMessageData:MailMessageData = new MailMessageData(target.id, false);
			if(target.readed == false)
			this.dispatchEventWith( PopupEvents.COMMAND_FROM_POPUP, false, mailMessageData );
		}
		
		//==================================================================================================
		private function HandleTriggerEvent(e:Event):void {
		//==================================================================================================
			const target:DisplayObject = DisplayObject(e.target)
			e.stopImmediatePropagation();
			trace(target);
			if(isTriggable == false) return;
			switch (target) 
			{
				case _btnNext:
					if(isNavPossible) NavigateNext();
					break;
				case _btnPrev:
					if(isNavPossible) NavigatePrev();
					break;
				case _btnClose:
					this.dispatchEventWith( PopupEvents.TAP_HAPPEND_CLOSE );
					break;
				case mail3.closeBtn:
				case mail2.closeBtn:
				case mail1.closeBtn:
					trace("REMOVE TRIGGER");
					if(MailMessage(target.parent).isAnimated == false)
					RemoveMailMessage(target.parent as MailMessage)
					break;
			}
		}
		
		//==================================================================================================
		private function RemoveMailMessage(mail:MailMessage):void {
		//==================================================================================================
			mailsCount -= 1;
			isTriggable = false;
			isNavPossible = false;
			
			if(mailMax >= mailsCount) _btnNext.enabled = false;
			
			Starling.juggler.tween( mail, MESSAGE_ANIM_TIME, { 
					alpha: 0
				,	x : (mail.x - mail.width)
				,	transition: Transitions.EASE_OUT
				,	onComplete: DeleteAnimationComplete
				,	onCompleteArgs: [ mail ]
			});
			this.dispatchEventWith( PopupEvents.COMMAND_FROM_POPUP, false, new MailMessageData(mail.id, true) );
			CheckMailCount();
		}
		
		//==================================================================================================
		private function NavigateNext():void {
		//==================================================================================================
			Starling.juggler.purge();
			isNavPossible = false;
			
			mail1.isAnimated = true;
			mail2.isAnimated = true;
			mail3.isAnimated = true;
			
			var tmpMail:MailMessage = mail1;
			Starling.juggler.tween(mail1, MESSAGE_ANIM_TIME * 0.8, { alpha:0, onComplete: function():void {
					mailMin++;
					mailMax++;
					
					mail1 = mail2;
					mail2 = mail3;
					mail3 = tmpMail;
					
					var mail1YPos:uint = MESSAGE_FIRST_Y;
					var mail2YPos:uint = mail1YPos + mail1.height + MESSAGE_DELTA_Y;
					var nextMail:uint = mailsCount - mailMax - 1;
					
					trace("NEXT AT:", mailsCount, mailMax, mailMin, nextMail);
					
					SetupMailMessage(tmpMail, mails[nextMail]);
					if(mailMax == (mailsCount - 1)) _btnNext.enabled = false; 
					if(_btnPrev.enabled == false) _btnPrev.enabled = true;
					
					Starling.juggler.tween(mail1, MESSAGE_ANIM_TIME * 0.8, { y:mail1YPos, transition: Transitions.EASE_OUT });
					Starling.juggler.tween(mail2, MESSAGE_ANIM_TIME * 0.8, { y:mail2YPos, delay:0.1, transition: Transitions.EASE_OUT, onComplete: AppendNewMail });
				}
			});
			
			function AppendNewMail():void {
				
				tmpMail.alpha = 0;
				tmpMail.scaleY = 1;
				tmpMail.y = SetNextMailYPosition(mail2) + MESSAGE_DELTA_Y
				
				Starling.juggler.tween(tmpMail, MESSAGE_ANIM_TIME, 
				{ alpha:1, y: mail3.y - MESSAGE_DELTA_Y, onComplete: function():void {
					isNavPossible = true;
					mail1.isAnimated = false;
					mail2.isAnimated = false;
					mail3.isAnimated = false;
				}});
			}
		}
		
		//==================================================================================================
		private function NavigatePrev():void {
		//==================================================================================================
			var tmpMail:MailMessage = mail3;
			isNavPossible = false;
			
			Starling.juggler.purge();
			Starling.juggler.tween(mail3, MESSAGE_ANIM_TIME * 0.8, { alpha:0, onComplete: function():void {
				
				tmpMail.y = MESSAGE_FIRST_Y;
				SetupMailMessage(tmpMail, mails[mailsCount - mailMin]);
				
				mail3 = mail2;
				mail2 = mail1;
				mail1 = tmpMail;
				
				var mail2YPos:uint = tmpMail.y + tmpMail.height + MESSAGE_DELTA_Y;
				var mail3YPos:uint = mail2YPos + mail2.height + MESSAGE_DELTA_Y;
				
				if(mailMax < mailsCount) _btnNext.enabled = true;
				else _btnNext.enabled = false;
				
				mailMin--;
				mailMax--;
				
				if(mailMin == 0) _btnPrev.enabled = false;
				
				trace(mailsCount, mailMin, mailMax);
				
				mail1.isAnimated = true;
				mail2.isAnimated = true;
				mail3.isAnimated = true;
				
				Starling.juggler.tween(mail3, MESSAGE_ANIM_TIME * 0.8, 
					{ y:mail3YPos, transition: Transitions.EASE_OUT });
				Starling.juggler.tween(mail2, MESSAGE_ANIM_TIME * 0.8, 
					{ y:mail2YPos, delay:0.1, transition: Transitions.EASE_OUT, onComplete: AppendNewMail });
			}
			});
			
			function AppendNewMail():void {
				tmpMail.alpha = 0;
				tmpMail.scaleY = 1;
				tmpMail.isAnimated = true;
				Starling.juggler.tween(tmpMail, MESSAGE_ANIM_TIME, 
					{ alpha:1, onComplete: function():void {
						isNavPossible = true;
						mail1.isAnimated = false;
						mail2.isAnimated = false;
						mail3.isAnimated = false;
						
					} })
			}
		}
		
		
		//==================================================================================================
		private function DeleteAnimationComplete( mail:MailMessage ):void {
		//==================================================================================================
			trace("DeleteAnimationComplete", mailsCount);
			Starling.juggler.purge();
			
			var mail1YPos:uint = mail1.y;
			var mail2YPos:uint = mail2.y;
			var mail3YPos:uint = mail3.y;
			
//			mailsCount = mails.length;
			//if(mailMax == mailsCount) mailMax = mailsCount - 1;
			
			function RemoveFirstMail():void {
				trace("REMOVE FIRST MAIL");
				
				mail2YPos = mail1.y + mail2.height + MESSAGE_DELTA_Y;
				mail3YPos = mail2YPos + mail3.height + MESSAGE_DELTA_Y;
				
				mail1 = mail2;
				mail2 = mail3;
				mail3 = mail;
				
				mails.removeAt(mails.length - mailMax + 1);
				
				
				// Смещаем второе и третье вверх
				Starling.juggler.tween( mail1, MESSAGE_ANIM_TIME * 0.8, { y:mail1YPos, transition: Transitions.EASE_OUT });
				Starling.juggler.tween( mail2, MESSAGE_ANIM_TIME * 0.8, { y:mail2YPos, transition: Transitions.EASE_OUT });
			}
			
			function RemoveSecondMail():void {
				trace("REMOVE SECOND MAIL");
				
				mail3YPos = mail2YPos + mail3.height + MESSAGE_DELTA_Y;
				
				mails.removeAt(mails.length - 1 - mailMax + 1);
				
				mail2 = mail3;
				mail3 = mail;
				
				// Смещаем только третье
				Starling.juggler.tween( mail2, MESSAGE_ANIM_TIME * 0.8, { y:mail2YPos });
			}
			
			if(mailsCount == 1) {
				if(mail == mail1) {
					mail1 = mail2;
					Starling.juggler.tween( mail1, MESSAGE_ANIM_TIME * 0.8, { y:mail1YPos });
				}
				isTriggable = true;
			}
			if(mailsCount == 2) {
				if(mail == mail1) RemoveFirstMail();
				else if(mail == mail2) RemoveSecondMail();
				isTriggable = true;
			}
			else if(mailsCount >= 3) {
				if (mail == mail2) RemoveSecondMail(); // Если удаляем второе
				else if(mail == mail1) RemoveFirstMail();  // Если удаляем первое письмо
				else mails.removeAt(mails.length - 1 - mailMax);
				
				trace("MAILS AFTER DELETE", mailMin, mailMax, mailsCount);
				if(mailsCount == 3) _btnNext.enabled = false;
				
				if(mailMax < mailsCount) {
					trace("NEW AT:", mailsCount, mailMax, mailMin, mailsCount - mailMax);
					
					SetupMailMessage( mail3, mails[mailsCount - mailMax - 1]);
					// Переносим убранное письмо в конец списка
					mail3.y = mail3YPos + MESSAGE_ANIM_OFFSET;
					mail3.x = mail2.x;
					mail3.alpha = 0;
					Starling.juggler.tween( mail3, MESSAGE_ANIM_TIME, { 
						alpha	: 1
					,	delay	: MESSAGE_ANIM_TIME
					, 	y		: mail3.y - MESSAGE_ANIM_OFFSET
					,	onComplete:function():void {
							if(mailMax == mailsCount) _btnNext.enabled = false;
							isTriggable = true;
							isNavPossible = true;
							
						}});
				} else {
					mail3.x = mail2.x;
					isTriggable = true;
					isNavPossible = true;
				}
			} else {
				isTriggable = true;
				isNavPossible = true;
			}
		}
		
		//==================================================================================================
		private function SetNextMailYPosition( prevmail:MailMessage ):uint {
		//==================================================================================================
			return prevmail.y + prevmail.height + MESSAGE_DELTA_Y;
		}	
		
		//==================================================================================================
		private function SetupMailMessage( mail:MailMessage, vo:MailVO ):void {
		//==================================================================================================
			mail.reset();
			mail.id = vo.id;
			mail.title = vo.title;
			mail.message = vo.message;
			mail.isSet = true;
			mail.isExpand = false;
			mail.readed = vo.isreaded;
			this.addChild(mail);
		}
		
		//==================================================================================================
		private function CheckMailCount( ):void {
		//==================================================================================================
//			if( mailsCount == 0 ) _txtCounter.removeFromParent();
//			else if( mailsCount >= 3 ) SetMailCount(3, mailsCount);
//			else SetMailCount( mailsCount, mailsCount );
		}
		
		//==================================================================================================
		private function SetMailCount( visible:int, length:int ):void {
		//==================================================================================================
//			if(_txtCounter.parent == null) this.addChild(_txtCounter);
//			_txtCounter.text = visible + " / " + length;
		}
	}
}
