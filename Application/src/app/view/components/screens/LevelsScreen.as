package app.view.components.screens 
{
	import flash.geom.Point;
	
	import app.view.components.scrollitems.LevelScrollItem;
	
	import consts.Colors;
	import consts.Fonts;
	import consts.Screens;
	import consts.assets.ButtonAssets;
	import consts.events.Events;

import nest.entities.application.Application;

import nest.entities.assets.Asset;
	import nest.entities.assets.AssetTypes;
	import nest.entities.screen.ScrollScreen;
	import nest.entities.scroller.ScrollerType;
	
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFieldAutoSize;
	import starling.text.TextFormat;
	import starling.textures.Texture;

	/**
	 * ...
	 * @author Vladimir Minkin
	 */
	public class LevelsScreen extends ScrollScreen 
	{
		public static const assets: Object = {
			graphic_item_level_closed	:  new Asset(AssetTypes.GRAPHIC, ScreenLevelsItemCGraphicAsset)
		,	graphic_item_level_opened	:  new Asset(AssetTypes.GRAPHIC, ScreenLevelsItemOGraphicAsset)
		};
		
		private const
			SF					: Number 	= Application.SCALEFACTOR
		,	OFFSET_Y_TITLE		: int 		= 52 	* SF
		,	OFFSET_Y_BUNDLE		: int 		= 8 	* SF
		,	OFFSET_Y_ELEMENTS	: int 		= 158 	* SF

		,	LEVELS_IN_ITEM		: uint 		= 9
			
		,	TITLE_HEIGHT		: int 		= 32 	* SF
		,	TITLE_FONTSIZE		: int 		= 28 	* SF
		
		,	BUNDLE_HEIGHT		: int 		= 24 	* SF
		,	BUNDLE_FONTSIZE		: int 		= 20 	* SF
		;
		
		public var 
			btnInfo		: Button
		,	btnBack		: Button
		;
		
		private var 
			_tfTitle			: TextField
		,	_tfBundle			: TextField
		,	_scrollItem			: LevelScrollItem
		,	_scrollItemIndex	: uint
		;
		
		public function LevelsScreen()
		{
			super(Screens.LEVELS)
			const BUTTONS : ButtonAssets = ButtonAssets.getInstance();

			const sw:uint =  Application.SCREEN_WIDTH;
			const sh:uint =  Application.SCREEN_HEIGHT;

			initScrollContainer(ScrollerType.HORIZONTAL);
			
			btnInfo = Asset(BUTTONS.info).clone;
			btnInfo.x = sw - btnInfo.width;
			btnInfo.y = 0;
			this.addChild(btnInfo);
			
			btnBack = Asset(BUTTONS.back).clone;
			btnBack.x = 0;
			btnBack.y = 0;
			this.addChild(btnBack);
			
			var referenceClosed:Texture = Asset(assets.graphic_item_level_closed).texture;
			var referenceOpened:Texture = Asset(assets.graphic_item_level_opened).texture;
			LevelScrollItem.Setup(referenceClosed, referenceOpened);
			
			_tfTitle = new TextField(1, TITLE_HEIGHT, "", new TextFormat(
				Fonts.ROBOTO_REGULAR, TITLE_FONTSIZE, Colors.LIGHT_BLUE
			));
			_tfTitle.autoSize	= TextFieldAutoSize.HORIZONTAL;
			_tfTitle.x 			= (sw - _tfTitle.width) * 0.5;
			_tfTitle.y 			= OFFSET_Y_TITLE;
			_tfTitle.batchable 	= true;
			_tfTitle.touchable 	= false;
			this.addChild(_tfTitle);
			
			_tfBundle = new TextField(1, BUNDLE_HEIGHT, "", new TextFormat(
				Fonts.ROBOTO_REGULAR, BUNDLE_FONTSIZE, Colors.BLACK_11
			));
			_tfBundle.autoSize	= TextFieldAutoSize.HORIZONTAL;
			_tfBundle.x 		= (sw - _tfBundle.width) * 0.5;
			_tfBundle.y 		= _tfTitle.y + _tfTitle.height + OFFSET_Y_BUNDLE;
			_tfBundle.batchable = true;
			_tfBundle.touchable = false;
			this.addChild(_tfBundle);

			_scrollContainer.y = OFFSET_Y_ELEMENTS;
			_scrollCounter.y = sh - _scrollCounter.y;
			
			this.addChild(_scrollContainer);
		}
		
		public function setTypeTitle(value:String):void {
			_tfTitle.text = value;
			_tfTitle.x = (Application.SCREEN_WIDTH - _tfTitle.width) * 0.5;
		}
		
		public function setBundleTitle(value:String):void {
			_tfBundle.text = value;
			_tfBundle.x = (Application.SCREEN_WIDTH - _tfBundle.width) * 0.5;
		}
		
		public function addElementToScrollItem(index:uint, locked:Boolean, completed:Boolean):void {
			var remainder:uint = index % LEVELS_IN_ITEM;
//			trace("remainder =",remainder, locked, completed);
			if(remainder == 0) {
				_scrollItem = new LevelScrollItem(index / LEVELS_IN_ITEM);
				_scrollContainer.addChild(_scrollItem);
				_scrollCounter.addCount(_scrollItem.index);
			}
			_scrollItem.addElement(locked, completed);
			if(remainder == (LEVELS_IN_ITEM - 1)) {
				_scrollItem.ready();
			}
		}
		
		public function setupScrollContainer():void {
			_scrollItem.ready();
			
			const scrollItemWidth	: uint = _scrollItem.width
			const scrollOffset		: uint = _scrollItem.offset;
			const scrollSize		: uint = _scrollItem.size;
			const scrollXPos		: int = (Application.SCREEN_WIDTH - scrollItemWidth) * 0.5;
			const scrollWidth		: uint = _scrollContainer.numChildren * scrollSize - scrollSize;
			
			_scrollContainer.x = scrollXPos;
			
			_scrollContainer.itemid = 0;
			_scrollContainer.minimum = scrollXPos;
			_scrollContainer.maximum = -scrollWidth + scrollXPos;
			_scrollContainer.itemsize = scrollSize;
			_scrollContainer.fadeFromCenter = false;
			_scrollContainer.doHoldAction = true;
			_scrollContainer.holdStartFunction = HoldStart;
			_scrollContainer.needTouchPoint = true;
			_scrollContainer.moveFunction = _scrollCounter.setActiveIndex;
			_scrollContainer.endFunction = TouchComplete;
			
			_scrollContainer.addBackground(scrollWidth + Application.SCREEN_WIDTH, _scrollContainer.height);
			
			if(_scrollCounter.numChildren == 1) {
				_scrollCounter.removeFromParent();
			} else {
				_scrollCounter.x = (Application.SCREEN_WIDTH - _scrollCounter.width) * 0.5;
				this.addChild(_scrollCounter)
			}
		}
		
		private function HoldStart(target:Sprite, position:Point):void
		{
			// TODO Auto Generated method stub
			trace("HoldStart", target, position, (target as LevelScrollItem).index);
			if(target is LevelScrollItem) {
				const index:int = FindTouchScrollContainerChildIndex(LevelScrollItem(target), position);
				if(index > -1) this.dispatchEventWith( Events.HOLD_START, false, index );
			}
		}
		
		//==================================================================================================
		public final function levelComplete(id:uint):void {
		//==================================================================================================
			// +1 потому что у нас есть подложка
			_scrollItem = _scrollContainer.getChildAt(_scrollItemIndex + 1) as LevelScrollItem;
			trace("> LevelsScreen - Complete Level:", id, _scrollItemIndex, _scrollItem);
			if(_scrollItem) _scrollItem.completeItemAt(id % LEVELS_IN_ITEM);
		}
		
		//==================================================================================================
		public final function levelReset(id:uint):void {
		//==================================================================================================
			trace("> LevelsScreen - Reset Level:", id, _scrollItemIndex);
			if(_scrollContainer && _scrollItemIndex > -1) {
				_scrollItem = _scrollContainer.getChildAt(_scrollItemIndex + 1) as LevelScrollItem;
				if(_scrollItem) _scrollItem.resetItemAt(id % LEVELS_IN_ITEM);
			}
		}
		
		//==================================================================================================
		public final function levelUnlock(id:uint):void {
		//==================================================================================================
			_scrollItem = _scrollContainer.getChildAt(_scrollItemIndex + 1) as LevelScrollItem;
			_scrollItem.unlockItemAt(id % LEVELS_IN_ITEM);
		}
		
		//==================================================================================================
		override public function hide(callback:Function = null):void {
		//==================================================================================================
			super.hide(callback);
		}
		
		private function TouchComplete(touchItemIndex:int, position:Point):void 
		{
			if (!isShow) return;
			trace(position);
			_scrollItemIndex = touchItemIndex;
			_scrollItem = _scrollContainer.getChildAt(touchItemIndex + 1) as LevelScrollItem;
			
			const index:int = FindTouchScrollContainerChildIndex(_scrollItem, position);
			if(index > -1) {
				this.dispatchEventWith(Events.TAP_HAPPEND_LEVEL, false, 
					{ index:index, locked:_scrollItem.isLockedAt(index), position:position });
			}
		}
		
		private function FindTouchScrollContainerChildIndex(target:LevelScrollItem, position:Point):int
		{
			const index:uint = target.index;
			
			var childW:uint, childH:uint;
			var localX:uint, localY:uint;
			
			var child			: DisplayObject;
			var localPosition	: Point;
			var elementsCount	: uint = Math.min(target.numItems, LEVELS_IN_ITEM);
			for (var i:int = 0; i < elementsCount; ++i) 
			{
				child = target.getItemAt(i) as DisplayObject;
				localPosition = child.globalToLocal(position);
				childW = child.width;
				childH = child.height;
				localX = localPosition.x;
				localY = localPosition.y;
				if (( localX > 0 && localX < childW ) && ( localY > 0 && localY < childH )) {
					return i + index * LEVELS_IN_ITEM;
				}
			}
			return -1;
		}
	}
}
