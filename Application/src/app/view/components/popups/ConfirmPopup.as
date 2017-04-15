package app.view.components.popups
{
	import app.model.data.popup.ConfirmPopupData;
	
	import consts.Colors;
	import consts.Fonts;
	import consts.Popups;
	
	import nest.entities.application.Application;
	import nest.entities.popup.Popup;
	import nest.entities.popup.PopupEvents;
	import nest.interfaces.IPopup;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Canvas;
	import starling.display.DisplayObject;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	import starling.utils.Align;
	
	public final class ConfirmPopup extends Popup implements IPopup
	{
		private static var _instance:ConfirmPopup;
		public static function getInstance():ConfirmPopup { 
			if (_instance == null) _instance = new ConfirmPopup();
			return _instance;
		}
		
		private static const STRING_OK:String = "OK";
		
		private const 
			sf					: Number 	= Application.SCALEFACTOR
		,	SW					: uint 		= Application.SCREEN_WIDTH
		,	SH					: uint	 	= Application.SCREEN_HEIGHT
		
		,	WIDTH				: uint	 	= SW * 0.618 * 0.8
		,	WIDTH_SHORT			: uint	 	= SW * 0.618 * 0.5
		,	XPOS				: uint		= ( SW - WIDTH ) * 0.5
		,	XPOS_SHORT			: uint		= ( SW - WIDTH_SHORT ) * 0.5
		,	BACK_COLOR			: uint	 	= 0x232323
		,	BACK_ALPHA			: Number 	= 0.9
		,	HEADER_COLOR		: uint		= Colors.BLACK_11
		,	HEADER_HEIGTH		: uint		= 64 * sf
		
		,	FOOTER_HEIGHT		: uint 		= 48 * sf
		,	FOOTER_COLOR		: uint 		= Colors.GREY_DD
		,	STATIC_HIGHT		: uint 		= HEADER_HEIGTH + FOOTER_HEIGHT
		
		,	TITLE_FONT_NAME		: String 	= Fonts.ROBOTO_CONDENSED
		,	TITLE_FONT_SIZE		: uint 		= 20 * sf
		,	TITLE_FONT_COLR		: uint 		= Colors.WHITE_F1
		
		,	MESSAGE_MARGIN_TB	: uint 		= 16 * sf
		,	MESSAGE_MARGIN_LR	: uint 		= 20 * sf
		,	MESSAGE_COLOR		: uint 		= Colors.WHITE_F1
		,	MESSAGE_FONT_NAME	: String 	= Fonts.ROBOTO_REGULAR
		,	MESSAGE_FONT_SIZE	: uint 		= 16 * sf
		,	MESSAGE_FONT_COLR	: uint 		= Colors.BLACK_23
		
		,	BTN_FONT_NAME		: String 	= Fonts.ROBOTO_BOLD
		,	BTN_FONT_SIZE		: uint 		= 16 * sf
		,	BTN_FONT_COLR		: uint 		= Colors.BLACK_23
		
		,	SEPARATOR			: uint		= 2 * sf
		,	SEPARATOR_CLR		: uint		= Colors.WHITE_FF
		;
			
		private var 
			_callback		: Function
		,	_btnConfirm 	: Button
		,	_btnCancel	 	: Button
		;
		
		private const 
			_canvas:Canvas = new Canvas()
		,	_txtTitle		: TextField = new TextField(WIDTH, HEADER_HEIGTH, "", new TextFormat(TITLE_FONT_NAME, TITLE_FONT_SIZE, TITLE_FONT_COLR))	
		,	_txtMessage		: TextField = new TextField(WIDTH - MESSAGE_MARGIN_LR * 2, 1, "", new TextFormat(MESSAGE_FONT_NAME, MESSAGE_FONT_SIZE, MESSAGE_FONT_COLR));	
		;
		
		public function ConfirmPopup() {
			super(Popups.CONFIRM);
			
			this.prioritet = 100;
			
			const btnTextFormat:TextFormat = new TextFormat(BTN_FONT_NAME, BTN_FONT_SIZE, BTN_FONT_COLR);
			const btnTexture:Texture = Texture.fromColor(WIDTH * 0.5, FOOTER_HEIGHT, FOOTER_COLOR);
			_btnConfirm = new Button(btnTexture);
			_btnConfirm.x = XPOS;
			_btnConfirm.textFormat = btnTextFormat;
			
			_btnCancel = new Button(btnTexture);
			_btnCancel.x = XPOS + _btnCancel.width;
			_btnCancel.textFormat = btnTextFormat;
			
			_txtTitle.format.verticalAlign = Align.CENTER;
			_txtTitle.format.horizontalAlign = Align.CENTER;
			_txtTitle.x = XPOS;
			_txtTitle.touchable = false;
			_txtTitle.batchable = true;
			
			_txtMessage.autoSize = TextFieldAutoSize.VERTICAL;
			_txtMessage.format.horizontalAlign = Align.LEFT;
			_txtMessage.format.leading = 3 * sf;
			_txtMessage.x = XPOS + MESSAGE_MARGIN_LR;
			_txtMessage.touchable = false;
			_txtMessage.batchable = true;
			_txtMessage.isHtmlText = true;
			
			_canvas.touchable = true;
			
			this.addChild(_canvas);
			this.addChild(_txtTitle);
			this.addChild(_txtMessage);
			this.addChild(_btnConfirm);
			this.addChild(_btnCancel);
			
			this.addEventListener(Event.TRIGGERED , HandleTriggerEvent);
		}
		
		//==================================================================================================
		private function HandleTriggerEvent(e:Event):void {
		//==================================================================================================
			e.stopImmediatePropagation();
			this.dispatchEventWith( PopupEvents.TAP_HAPPEND_CLOSE );
			switch (DisplayObject(e.target)) {
				case _btnCancel: ExecuteCallbackWithAnswer(false); break;
				case _btnConfirm: ExecuteCallbackWithAnswer(true); break;
			}
		}
		
		//==================================================================================================
		override public function androidBackButtonPressed():void { 
		//==================================================================================================
			CallCallback(false);
		}
		
		//==================================================================================================
		override public function localize( data:XMLList ):void { 
		//==================================================================================================
			_btnConfirm	.text = String(data.@yes);
			_btnCancel	.text = String(data.@no);
			this._locale = new XMLList(<locale><yes>{data.@yes}</yes><no>{data.@no}</no></locale>);
		};

		//==================================================================================================
		override public function prepare( params:Object ):void { 
		//==================================================================================================
			const data:ConfirmPopupData = ConfirmPopupData(params);
			const message:String = data.message;
			
			_callback = data.callback;
			_txtTitle.text = data.title;
			_txtMessage.text = message;
			
			const isTwoButton		: Boolean = (_callback != null) && (data.single == false);
			const messageLength		: uint = message.split("\n")[0].length;
			const isShortMessage	: Boolean = messageLength < 30; 
			
//			trace(message,"\nmessageLength:", messageLength, data.single);
			
			var messageWidth	:uint;
			var messageXPos		:uint;
			var btnTexture		:Texture;
			
			if(isShortMessage) {
				_txtMessage.format.horizontalAlign = Align.CENTER;
				messageWidth = WIDTH_SHORT;
				messageXPos = XPOS_SHORT;
			}
			else {
				_txtMessage.format.horizontalAlign = messageLength > 50 ? Align.LEFT : Align.CENTER;
				messageWidth = WIDTH;
				messageXPos = XPOS;
			}
			
			var buttonWidth:uint = messageWidth;
			if(isTwoButton) buttonWidth *= 0.5;
			
			btnTexture = Texture.fromColor(buttonWidth, FOOTER_HEIGHT, FOOTER_COLOR, 0)
			
			_btnConfirm.x = messageXPos;
			_btnConfirm.upState = btnTexture;
			_btnConfirm.readjustSize();
			
			if(isTwoButton) {
				_btnCancel.upState = btnTexture;
				_btnCancel.readjustSize();
				_btnCancel.x = messageXPos + buttonWidth;
				if(_btnCancel.parent == null){
					_btnCancel.text = String(this._locale.no); // См. функцию localize
					this.addChild(_btnCancel);
				}
				_btnConfirm.text = String(this._locale.yes); // <locale><yes>{data.@yes}</yes><no>{data.@no}</no></locale>
			} else {
				_btnConfirm.text = STRING_OK;
				_btnCancel.removeFromParent();
			}
			
			const messageHeight		:uint = _txtMessage.height;
			const ypos				:uint = Draw(messageHeight, messageWidth, messageXPos, isTwoButton);
			const messageY			:uint = ypos + HEADER_HEIGTH + MESSAGE_MARGIN_TB*2;
			const buttonY			:uint = messageY + messageHeight + MESSAGE_MARGIN_TB*2;
			
			_txtTitle	.y = ypos;
			_txtMessage	.y = messageY;
			_btnConfirm	.y = buttonY;
			_btnCancel	.y = buttonY;
		};
		
		override public function show():void {
			_instance.alpha = 0;
			Starling.juggler.tween(_instance, 0.2, {alpha:1});
		}
		
		override public function hide(next:Function):void {
			Starling.juggler.tween(this, 0.2, { alpha:0, onComplete:next, onCompleteArgs:[this.name]});
		}
		
		private function ExecuteCallbackWithAnswer(answer:Boolean):void
		{
			CallCallback(answer);
		}
		
		private function CallCallback(result:Boolean):void
		{
			if(_callback) {
				switch(_callback.length)
				{
					case 1:	_callback(result); 	break;
					case 0: _callback(); 		break;
				}
			}
		}
		
		private function Draw(messageHeight:uint, messageWidth:uint, messageXPos:uint, isTwoButton):uint
		{
			const ytop_header		:uint = (SH - (STATIC_HIGHT + messageHeight)) * 0.382;
			const ytop_message		:uint = ytop_header + HEADER_HEIGTH;
			const message_height	:uint = messageHeight + MESSAGE_MARGIN_TB * 4;
			const ytop_footer		:uint = ytop_header + HEADER_HEIGTH + message_height;
			
			_canvas.clear();
			
			_canvas.beginFill(BACK_COLOR, BACK_ALPHA);
			_canvas.drawRectangle(0,0,SW,SH);
			_canvas.endFill();
			
			_canvas.beginFill(SEPARATOR_CLR);
			_canvas.drawRectangle(messageXPos-SEPARATOR,ytop_header-SEPARATOR,messageWidth + SEPARATOR*2, HEADER_HEIGTH + message_height + FOOTER_HEIGHT + SEPARATOR*2);
			_canvas.endFill();
			
			_canvas.beginFill(HEADER_COLOR);
			_canvas.drawRectangle(messageXPos, ytop_header, messageWidth, HEADER_HEIGTH);
			_canvas.endFill();
			
			_canvas.beginFill(MESSAGE_COLOR);
			_canvas.drawRectangle(messageXPos, ytop_message, messageWidth, message_height);
			_canvas.endFill();
						
			_canvas.beginFill(FOOTER_COLOR);
			_canvas.drawRectangle(messageXPos, ytop_footer, messageWidth, FOOTER_HEIGHT);
			_canvas.endFill();

			if(SEPARATOR > 0) {
				_canvas.beginFill(SEPARATOR_CLR);
				_canvas.drawRectangle(messageXPos, ytop_footer-SEPARATOR, messageWidth, SEPARATOR);
				if(isTwoButton) {		
					_canvas.drawRectangle(messageXPos + messageWidth * 0.5, ytop_footer, SEPARATOR, FOOTER_HEIGHT);
				}
				_canvas.endFill();
			}
			
			return ytop_header;
		}
	}
}