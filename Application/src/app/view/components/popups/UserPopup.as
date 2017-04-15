package app.view.components.popups 
{
	import flash.geom.Rectangle;
	
	import consts.Colors;
	import consts.Fonts;
	import consts.Popups;
	import consts.assets.ButtonAssets;
	
	import nest.entities.application.Application;
	import nest.entities.assets.Asset;
	import nest.entities.assets.AssetTypes;
	import nest.entities.popup.Popup;
	import nest.entities.popup.PopupEvents;
	import nest.entities.scroller.PageScroller;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import starling.utils.VAlign;

	/**
	 * ...
	 * @author Vladimir Minkin
	 */
	public final class UserPopup extends Popup
	{
		public static const assets: Object = {
			graphic_item_achivement		:  new Asset(AssetTypes.GRAPHIC, PopupUserItemGraphicAsset)
		};
		
		private static var instance:UserPopup;
		
		private const sf				:Number 	= Application.SCALEFACTOR;
		private const SW				:uint 		= Application.SCREEN_WIDTH;
		private const SH				:uint	 	= Application.SCREEN_HEIGHT;

		private const	
			BACK_ALPHA		: Number = 1
		,	BACK_COLOR		: Number = Colors.BLACK_00
		
		,	NAME_WIDTH			:uint 		= 400 	* sf
		,	NAME_HEIGHT			:uint 		= 50 	* sf
		,	NAME_FONT_SIZE		:uint 		= 34 	* sf
		,	NAME_FONT_NAME		:String 	= Fonts.LATO_HEAVY
		,	NAME_FONT_COLR		:uint 		= Colors.WHITE_FF
		,	NAME_X				:uint 		= 120 	* sf
		,	NAME_Y				:uint 		= 74 	* sf
		
		,	SST_WIDTH			:uint 		= 150 	* sf
		,	SST_VALUE_WIDTH		:uint 		= 500 	* sf
		,	SST_HEIGHT			:uint 		= 120 	* sf
		,	SST_FONT_NAME		:String 	= Fonts.LATO_REGULAR
		,	SST_FONT_SIZE		:uint 		= 18 	* sf
		,	SST_FONT_COLR		:uint 		= Colors.WHITE_FF
		,	SST_X				:uint 		= 50 	* sf
		,	SST_Y				:uint 		= 150 	* sf
		,	SST_VALUE_OFFSET_X	:Number 	= 10 	* sf
		
		,	ACH_WIDTH			:uint 		= 200 	* sf
		,	ACH_HEIGHT			:uint 		= 30 	* sf
		,	ACH_FONT_SIZE		:uint 		= 24 	* sf
		,	ACH_FONT_NAME		:String 	= Fonts.LATO_HEAVY
		,	ACH_FONT_COLR		:uint 		= Colors.WHITE_FF
		,	ACH_Y				:uint 		= 344 	* sf
		,	ACH_ITEM_OFFSET_X	:Number 	= 30 	* sf
		,	ACH_ITEM_OFFSET_Y	:Number 	= 25 	* sf
		
		,	SCROLLER_OFFSET_Y	:uint 		= 48 	* sf
		,	SCROLLER_HEIGHT		:uint 		= 280 	* sf
		,	SCROLLER_ITEM_W		:uint 		= 550 	* sf
		,	SCROLLER_ITEM_H		:uint 		= 300 	* sf
		;

		private const SST_VALUES:Array = ["0", "1", "2"];
		
		private var 
			buttonClose		: Button
		,	buttonFlag		: Button
		,	buttonLighting	: Button
		,	textLayer		: Sprite
		
		,	nameTF			: TextField
		,	achTF			: TextField
		,	sstTF			: TextField
		,	sstValueTF		: TextField
		;

		private const background:Quad = new Quad(SW, SH, BACK_COLOR);
		
		private var _command:String = "";
		
		public function UserPopup() 
		{
			super( Popups.USER );
			
			const BUTTONS : ButtonAssets = ButtonAssets.getInstance();
			
			background.alpha = BACK_ALPHA;
			this.addChild(background);
			
			const HCENTER:uint = SW * 0.50;
			const VCENTER:uint = SH * 0.50 - 100 * sf;
			
			buttonClose 	= Asset(BUTTONS.close).clone;
			buttonClose.x 	= SW - buttonClose.width;
			buttonClose.y 	= 0;
			this.addChild(buttonClose);
			
			buttonFlag 	= Asset(BUTTONS.flag).obj;
			buttonFlag.x 	= 900 * sf;
			buttonFlag.y 	= 260 * sf;
			this.addChild(buttonFlag);
			
			buttonLighting 	= Asset(BUTTONS.lighting).obj;
			buttonLighting.x 	= buttonFlag.x + buttonFlag.width + 5 * sf;
			buttonLighting.y 	= buttonFlag.y;
			this.addChild(buttonLighting);
			
			textLayer = new Sprite();
			
			nameTF = new TextField(NAME_WIDTH, NAME_HEIGHT, "ИМЯ ФАМИЛИЯ", NAME_FONT_NAME, NAME_FONT_SIZE, NAME_FONT_COLR);
			nameTF.x = NAME_X;
			nameTF.y = NAME_Y;
			nameTF.hAlign = HAlign.LEFT;
			nameTF.vAlign = VAlign.TOP;
			nameTF.touchable = false;
			nameTF.batchable = true;
			textLayer.addChild(nameTF);
			
			sstTF = new TextField(SST_WIDTH, SST_HEIGHT, "СТАТУС :\n\nОЧКИ :\n\nВРЕМЯ ИГРЫ :", SST_FONT_NAME, SST_FONT_SIZE, SST_FONT_COLR);
			sstTF.x = SST_X;
			sstTF.y = SST_Y;
			sstTF.hAlign = HAlign.RIGHT;
			sstTF.vAlign = VAlign.TOP;
			sstTF.touchable = false;
			sstTF.batchable = true;
			textLayer.addChild(sstTF);
			
			SST_VALUES[0] = "Знаток, мастер передвижения";
			SST_VALUES[1] = "15993";
			SST_VALUES[2] = "2 дня 15 часов 33 минуты";
			
			sstValueTF = new TextField(SST_VALUE_WIDTH, SST_HEIGHT, SST_VALUES.join("\n\n"), SST_FONT_NAME, SST_FONT_SIZE, SST_FONT_COLR);
			sstValueTF.x = SST_X + sstTF.width + SST_VALUE_OFFSET_X;
			sstValueTF.y = SST_Y;
			sstValueTF.hAlign = HAlign.LEFT;
			sstValueTF.vAlign = VAlign.TOP;
			sstValueTF.touchable = false;
			sstValueTF.batchable = true;
			textLayer.addChild(sstValueTF);
			
			achTF = new TextField(ACH_WIDTH, ACH_HEIGHT, "ДОСТИЖЕНИЯ", ACH_FONT_NAME, ACH_FONT_SIZE, ACH_FONT_COLR);
			achTF.x = HCENTER - achTF.width * 0.5;
			achTF.y = ACH_Y;
			achTF.touchable = false;
			achTF.batchable = true;
			textLayer.addChild(achTF);
			
			textLayer.touchable = false;
			textLayer.flatten();
			
			var pagewidth:uint = SW;
			
			var countersize:uint = 10 * sf;
			var counteroffset:uint = 10 * sf;
			var viewport:Rectangle = new Rectangle(0, 0, SW, SCROLLER_HEIGHT);
			var scroller:PageScroller = new PageScroller(this, pagewidth, viewport, countersize, counteroffset); // the content you want to scroll
			
			var achiveItemBackImage:Image = Image(Asset(assets.graphic_item_achivement).obj);
			var achiveItemBackTexture:Texture = achiveItemBackImage.texture;
			var achiveItemBackSize:uint = achiveItemBackImage.width;
			var xPos:uint = 0;
			var yPos:uint = 0;
			var offsetX:uint = achiveItemBackSize + ACH_ITEM_OFFSET_X;
			var offsetY:uint = achiveItemBackSize + ACH_ITEM_OFFSET_Y;
			var item:Image;
			var back:Quad;
			var itemContainer:Sprite;
			for (var i:int = 0; i < 6; i++) 
			{
				itemContainer = new Sprite();
				back = new Quad(SCROLLER_ITEM_W, SCROLLER_ITEM_H, 0xffcc00 + i * 0x005555);
				back.alpha = 0.0;
				itemContainer.addChild(back);
				xPos = 0;
				yPos = 0;
				for (var j:int = 0; j < 18; j++) 
				{
					item = new Image(achiveItemBackTexture);
					xPos = j % 6;
					item.x = offsetX * xPos;
					item.y = offsetY * yPos;
					item.touchable = false;
					itemContainer.addChild(item);
					if (xPos == 5) yPos++;
				}
				itemContainer.flatten();
				scroller.addPage(itemContainer);
			}
			scroller.itemwidth = SCROLLER_ITEM_W;
			scroller.y = achTF.y + achTF.height + SCROLLER_OFFSET_Y;
			scroller.start();
			
			this.addChild(textLayer);
			this.addEventListener(Event.ADDED_TO_STAGE, HandleAddToStage);
		}
		
		public static function getInstance():UserPopup { 
			if (instance == null) instance = new UserPopup();
			return instance;
		}
		
		//==================================================================================================
		override public function localize(data:XMLList):void {
		//==================================================================================================

		}
		
		//==================================================================================================
		override public function prepare(data:Object):void {
		//==================================================================================================
				
		}
		
		//==================================================================================================
		override public function show():void {
		//==================================================================================================
			
		}
		
		//==================================================================================================
		override public function hide(next:Function):void {
		//==================================================================================================
			super.hide(next);
		}
		
		//==================================================================================================
		private function HandleAddToStage(e:Event):void {
		//==================================================================================================
			this.removeEventListener(Event.ADDED_TO_STAGE, HandleAddToStage);
			
			this.addEventListener(Event.REMOVED_FROM_STAGE, HandleRemoveFromStage);
			this.addEventListener(Event.TRIGGERED, HandleTriggerEvent);
		}
		
		//==================================================================================================
		private function HandleRemoveFromStage(e:Event):void {
		//==================================================================================================
			this.removeEventListener(Event.REMOVED_FROM_STAGE, HandleRemoveFromStage);
			this.removeEventListener(Event.TRIGGERED, HandleTriggerEvent);
			
			this.addEventListener(Event.ADDED_TO_STAGE, HandleAddToStage);
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
