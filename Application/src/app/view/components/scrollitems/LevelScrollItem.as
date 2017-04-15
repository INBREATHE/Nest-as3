package app.view.components.scrollitems {
	
	import consts.Colors;
	import consts.Fonts;
	import consts.assets.IconAssets;
	
	import nest.entities.application.Application;
	import nest.entities.assets.Asset;
	import nest.interfaces.IScrollItem;
	
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.textures.Texture;
	
	/**
	 * ...
	 * @author Vladimir Minkin
	 */
	public class LevelScrollItem extends Sprite implements IScrollItem
	{
		private static const NAME_BACK:String = "back";
		private static const NAME_TF:String = "tf";
		
		private static const ICONS:IconAssets = IconAssets.getInstance();
		
		private static var 
			CLOSED_TEXTURE		: Texture
		,	OPENED_TEXTURE		: Texture
		,	ELEMENT_SIZE		: int = int.MAX_VALUE
		,	ELEMENT_POS_SIZE_X	: int = int.MAX_VALUE
		,	ELEMENT_POS_SIZE_Y	: int = int.MAX_VALUE
		,	ELEMENT_X_OFFSET	: int = int.MAX_VALUE
		,	ELEMENT_Y_OFFSET	: int = int.MAX_VALUE
		,	MARGIN_RIGHT		: int = int.MAX_VALUE
		
		,	COUNT_W				: uint = uint.MAX_VALUE
		,	COUNT_H				: uint = uint.MAX_VALUE
		,	COUNT_FONT_SIZE_C	: uint = uint.MAX_VALUE
		,	COUNT_FONT_SIZE_O	: uint = uint.MAX_VALUE
		,	COUNT_FONT_COLOR_C	: uint = Colors.BLACK
		,	COUNT_FONT_COLOR_O	: uint = Colors.WHITE_FF
		,	COUNT_FONT_NAME		: String = Fonts.BF_LATO_INDEXIES
		
		,	COUNT_Y_MULT		: Number = 0.1
		
		;
			
		public static function Setup(textureClosed:Texture, textureOpened:Texture):void 
		{
			LevelScrollItem.CLOSED_TEXTURE = textureClosed;
			LevelScrollItem.OPENED_TEXTURE = textureOpened;
			
			const SCALEFACTOR 		: uint = Application.SCALEFACTOR
			const DELTA_X_ELEMENTS	: int = 40 * SCALEFACTOR;
			const DELTA_Y_ELEMENTS	: int = 30 * SCALEFACTOR;
			
			ELEMENT_SIZE 		= CLOSED_TEXTURE.width;
			ELEMENT_X_OFFSET 	= ELEMENT_SIZE + DELTA_X_ELEMENTS;
			ELEMENT_Y_OFFSET 	= ELEMENT_SIZE + DELTA_Y_ELEMENTS;
			
			COUNT_W = ELEMENT_SIZE;
			COUNT_H = 40 * SCALEFACTOR;
			COUNT_FONT_SIZE_C = COUNT_H;
			COUNT_FONT_SIZE_O = 28 * SCALEFACTOR;
			
			ELEMENT_POS_SIZE_X = ( ELEMENT_SIZE - COUNT_W ) *0.5;
			ELEMENT_POS_SIZE_Y = ELEMENT_SIZE - COUNT_H;
			
			MARGIN_RIGHT		= 300 * SCALEFACTOR;
			
		} 
		
		private var 
			_index:uint
		,	_locked:Vector.<Boolean> = new <Boolean>[]
		,	_completed:Vector.<Boolean> = new <Boolean>[]
		,	_indexLayers:Sprite = new Sprite()
		,	_backLayer:Sprite = new Sprite()
		,	_col:uint = 0, _row:uint = 0
		;

		public function get index():uint { return _index; }

		public function isLocked():Boolean { return false; }
		public function isLockedAt(index:uint):Boolean { return Boolean(_locked[index]); }
		
		public function completeItemAt(value:uint):void {
			trace(" completeElementAt:", _completed[value])
			CompleteElement(value);
			_completed[value] = true;
		}
		
		public function resetItemAt(value:uint):void {
			trace(" resetElementAt:", _completed[value])
			if(_completed[value]) {
				ResetElement(value);
			}
			_completed[value] = false;
		}
		
		public function unlockItemAt(value:uint):void {
			trace(" unlockItemAt:", value, _locked[value])
			
			_locked[value] = false;
			
			value = value + 1;
			var backImage:Image = _backLayer.getChildByName(NAME_BACK + value) as Image;
			var tf:TextField = _indexLayers.getChildByName(NAME_TF + value) as TextField;
			if(tf) {
				tf.format.color = COUNT_FONT_COLOR_O;
				tf.format.size = COUNT_FONT_SIZE_O;
				tf.y = backImage.y + ELEMENT_POS_SIZE_Y * COUNT_Y_MULT;
			}
			
			backImage.texture = OPENED_TEXTURE;
			backImage.readjustSize();
		}
		
		public function getItemAt(index:uint):DisplayObject {
			return _backLayer.getChildAt(index);
		}
		
		override public function get width():Number {
			return (ELEMENT_X_OFFSET * 2 + ELEMENT_SIZE);
		}
		
		public function get size():uint {
//			this.addChildAt(new Quad(uint(width + MARGIN_RIGHT)-1, 200, 0xffcc00), 0);
			return uint(width + MARGIN_RIGHT);
		}
		
		public function get offset():uint {
			return MARGIN_RIGHT;
		}
		
		public function get numItems():int {
			return _backLayer.numChildren;
		}
		
		public function ready():void {
			this.y = 0;
			this.pivotX = width * 0.5;
			this.x = this.pivotX + this.size * _index;
			this.touchGroup = true;
			this.touchable = true;
		}
		
		public function LevelScrollItem(index:uint) {
			super();
			
			this._index = index;
			
			this.addChild(_backLayer);
			this.addChild(_indexLayers);
		}
		
		public function show():void {}
		public function hide():void {}
		
		public function addElement(locked:Boolean, completed:Boolean):void
		{
			var backImage:Image = new Image(locked ? CLOSED_TEXTURE : OPENED_TEXTURE);
			var count:uint = _col + _row * 3 + index * 9 + 1;
			
			backImage.name = NAME_BACK+count;
			backImage.x = _col * ELEMENT_X_OFFSET;
			backImage.y = _row * ELEMENT_Y_OFFSET;
			
//			if(!locked) backImage.color = Colors.WHITE;
			_backLayer.addChild(backImage);
			
			if(completed) CompleteElement(_backLayer.numChildren - 1);
			else {
				var tf:TextField = new TextField(
					COUNT_W,
					COUNT_H, 
					count.toString(),
					new TextFormat(
						COUNT_FONT_NAME,
						locked ? COUNT_FONT_SIZE_C : COUNT_FONT_SIZE_O,
						locked ? COUNT_FONT_COLOR_C : COUNT_FONT_COLOR_O
					)
				);
				tf.x = backImage.x + ELEMENT_POS_SIZE_X;
				tf.y = backImage.y + ELEMENT_POS_SIZE_Y * ( locked ? 0.425 : COUNT_Y_MULT);
				tf.batchable = true;
				tf.touchable = false;
				tf.name = NAME_TF + count;
				_indexLayers.addChild(tf);
			}
			
			_locked.push(locked);
			_completed.push(completed);
			
			if (++_col == 3) {
				_col = 0;
				_row++;
			}
		}
		
		private function CompleteElement(id:uint):void
		{
			id = id + 1;
			var backImage:Image = _backLayer.getChildByName(NAME_BACK + id) as Image;
			var tf:TextField = _indexLayers.getChildByName(NAME_TF + id) as TextField;
			
			trace("CompleteElement", backImage, tf);
			
			if(backImage) {
				backImage.texture = Asset(ICONS.protect).texture;
				backImage.readjustSize();
			}
			
			if(tf) tf.removeFromParent(true);
			
			tf = null;
			backImage = null;
		}
		
		private function ResetElement(id:uint):void
		{
			var backImage:Image = _backLayer.getChildAt(id) as Image;
			id = id+index * 9 + 1;
			
			if(backImage) {
				backImage.texture = OPENED_TEXTURE;
				backImage.readjustSize();
			}
			
			var tf:TextField = new TextField(
				COUNT_W,
				COUNT_H, 
				id.toString(),
				new TextFormat(
					COUNT_FONT_NAME,
					COUNT_FONT_SIZE_O,
					COUNT_FONT_COLOR_O
				)
			);
			
			tf.name = NAME_TF + id;
			tf.x = backImage.x + (ELEMENT_SIZE - COUNT_W) * 0.5;
			tf.y = backImage.y + (ELEMENT_SIZE - COUNT_H) * 0.1;
			
			_indexLayers.addChild(tf);
			
			tf = null;
			backImage = null;
		}
	}

}
