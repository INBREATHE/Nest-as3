package app.view.components.games {
	import flash.geom.Point;
	
	import app.model.data.game.CrosswordGameData;
	import app.model.data.game.base.GameData;
	import app.model.data.update.CrosswordUpdateData;
	import app.model.vo.game.crossword.QuestionVO;
	import app.view.components.bases.GameBase;
	
	import consts.Colors;
	import consts.Defaults;
	import consts.Fonts;
	import consts.Specials;
	import consts.events.Events;
	
	import nest.entities.application.Application;
	import nest.interfaces.IGame;
	
	import starling.display.MeshBatch;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFormat;
	import starling.utils.Align;
	
	public class CrosswordGame extends GameBase implements IGame
	{
		private static var __instance:CrosswordGame;
		
		static  private const ACTION_ANSWERED_QUESTION:uint = 0;
		
		private const
			SCALEFACTOR			:Number 	= Application.SCALEFACTOR
		,	TILE_SIZE			:uint 		= Defaults.CROSSWRD_TILE_SIZE * SCALEFACTOR
		,	TILE_OFFSET			:Number 	= 1 * SCALEFACTOR
		
		,	TAP_ACCURACY		:uint		= 10 * SCALEFACTOR
		,	TAP_TOLERANCE		:uint 		= 10 * SCALEFACTOR
		
		,	INNER_SIZE			:Number 	= TILE_SIZE - TILE_OFFSET
		,	INNER_COLOR			:uint 		= Colors.BLACK_23
		,	TILE_COLOR			:uint 		= Colors.BLACK_44
		,	BGR_COLOR			:uint 		= Colors.WHITE_FC
		
			
		,	ANSWER_FONT_NAME	:String 	= Fonts.BF_LATO_HEAVY
		,	ANSWER_FONT_SIZE	:uint		= 28 * SCALEFACTOR
		,	ANSWER_COLOR		:uint		= Colors.WHITE_FF
		
		,	ANSWER_CHAR_FORMAT	:TextFormat = new TextFormat(ANSWER_FONT_NAME, ANSWER_FONT_SIZE, ANSWER_COLOR)	
		
		,	INDEX_WIDTH			:uint 		= TILE_SIZE * 0.4
		,	INDEX_HEIGHT		:uint 		= TILE_SIZE * 0.3
		,	INDEX_OFFSET		:uint 		= 3 * SCALEFACTOR
		,	INDEX_FONT_NAME		:String 	= Fonts.BF_LATO_INDEXIES
		,	INDEX_FONT_SIZE		:uint 		= 13 * SCALEFACTOR
		,	INDEX_COLOR			:uint 		= Colors.GREY_AA
		;
		
		private var 
			_backgroundLayer	:MeshBatch = new MeshBatch()
		,	_charactersLayer	:Sprite = new Sprite()
		,	_indexiesLayer		:Sprite = new Sprite()
		,	_tilesLayer			:Sprite = new Sprite()
			
		,	_touchStartPoint	:Point = new Point()
		,	_touchEndPoint		:Point = new Point()
			
		,	_positionMinX:int, _positionMinY:int
		,	_positionMaxX:int, _positionMaxY:int
		,	_position:Point
		
		,	_isTapPossible		:Boolean = false
		,	_isHMovePossible	:Boolean = true
		,	_isVMovePossible	:Boolean = true
		
		;
		
		private var tileTapIndex:int = int.MAX_VALUE;
		private var _questionVO:QuestionVO;
		
		
		public function CrosswordGame() { if (__instance) throw ("Sorry but This is Singleton, try to use getInstance"); }
		public static function getInstance():CrosswordGame { if (__instance == null) __instance = new CrosswordGame(); return __instance; }
		override final public function init(actions:Vector.<String>):void {
		//==================================================================================================
			gridXMax = ROWS;
			gridYMax = COLUMNS;
		
			super.init(actions);
			ResetStageScale();
		}
		//==================================================================================================
		public final function update(input:Object):void {
		//==================================================================================================
			var data:CrosswordUpdateData = CrosswordUpdateData(input);
			
			_questionVO = data.answeredQuestionVO;
			gridX 		= _questionVO.x;
			gridY 		= _questionVO.y;
			
			const characters	:Array 		= _questionVO.letters;
			const direction		:Boolean 	= _questionVO.direction;
			const horizontal	:int 		= direction ? 1 : 0;
			const vertical		:int 		= direction ? 0 : 1;
			const qindex		:uint 		= _questionVO.index;
			const qlength		:uint 		= _questionVO.length;
			
			var counter		: uint = uint.MAX_VALUE;
			var character	: String = "";
			var textField	: TextField;
			
			var tempQVO		: QuestionVO;
			var tempIndex	: uint = uint.MAX_VALUE;
			
			var alsoAnswered:Array = new Array();
						
			counter = 0;
			while(counter < qlength)
			{
				anchorGridValue = anchorGrid.getValue(gridX, gridY);
				gameGridValue 	= gameGrid.getValue(gridX, gridY);
				
				tileX = gridX * TILE_SIZE;
				tileY = gridY * TILE_SIZE;
				
				character = characters[counter];
				if(gameGridValue == 0 && character && character != Specials.CROSSWORD_ANSWER_CACHE_DIVIDER) {
					character = character.toUpperCase();
					textField = new TextField(TILE_SIZE, TILE_SIZE, character, ANSWER_CHAR_FORMAT);
					textField.touchable = false;
					textField.batchable = true;
					textField.x = tileX;
					textField.y = tileY;
					_charactersLayer.addChild(textField);
					
					gameGridValue = character.charCodeAt();
					gameGrid.setValue(gridX, gridY, gameGridValue);
					
					// Также смотрим если в этой ячейке есть другой вопрос и он не отвечен
					// то мы добавляем к этому вопросу букву и проверяем его на выполнение
					if (anchorGridValue > 100) { 
						tempIndex = Math.floor(anchorGridValue * 0.01);
						if (tempIndex == qindex) anchorGridValue = anchorGridValue - tempIndex * 100;
						else anchorGridValue = tempIndex;
						tempQVO = data.questions[anchorGridValue - 1];
						if (!tempQVO.answered) {
							tempIndex = Math.abs((tempQVO.x - gridX) + (tempQVO.y - gridY));
							tempQVO.letters[tempIndex] = character;
							// Если мы правильно заполняем вопрос, то заносим его в учет
							if(tempQVO.answer == tempQVO.letters.join("")) {
								trace("ANOTHER QUESTION IS ANSWERED", tempQVO.answer);
								tempQVO.answered = true;
								alsoAnswered.push(tempQVO);
							}
						}
					}
				} 
				
				gridX += horizontal;
				gridY += vertical;
				
				counter++;
			}
			
			// Если у нас есть найденные отвеченные вопросы, то мы отправляем их на проверку и учет
			// Событие commandOnAction = GameCommands.ANSWERED_QUESTION
			// Команда AnsweredQuestionCommand
			while(alsoAnswered.length) {
				this.dispatchToExecuteAction( ACTION_ANSWERED_QUESTION, alsoAnswered.shift() );
			}
		}
		
		//==================================================================================================
		public function show():void {
		//==================================================================================================			
		}
		
		//==================================================================================================
		public function hide(callback:Function = null):void {
		//==================================================================================================
//			this.removeFromParent();
		}
		
		//==================================================================================================
		public function reset():void {
		//==================================================================================================
			this.removeFromParent();
			
			while (_tilesLayer.numChildren) _tilesLayer.removeChildAt(0, true);
			while (_charactersLayer.numChildren) _charactersLayer.removeChildAt(0, true);
			while (_indexiesLayer.numChildren) _indexiesLayer.removeChildAt(0, true);
			
			_backgroundLayer.clear();
			
			_backgroundLayer.removeFromParent(true);
			_charactersLayer.removeFromParent(true);
			_indexiesLayer.removeFromParent(true);
			_tilesLayer.removeFromParent(true);
			
			_backgroundLayer.x = 0;
			_backgroundLayer.y = 0;
		}
		
		//==================================================================================================
		public function build(input:GameData):void {
		//==================================================================================================
			const data:Array = CrosswordGameData(input).data;
			
			anchorGrid.init(ROWS, COLUMNS);
			gameGrid.init(ROWS, COLUMNS);
			
			gridXMax = 0;
			gridYMax = 0;
			
			var tempQVO		:QuestionVO;
			
			var counter		:uint = 0;
			var label		:uint = 1;
			
			var qlabel		:uint = 1;
			var qindex		:uint = 1;
			var qlength		:uint = 0;
			
			var characters	:Array;
			var character	:String;
			
			var skipArray	:Array;
			var skipIndex	:int;
			
			var direction	:Boolean;
			var answered	:Boolean;
			
			var horizontal	:int;
			var vertical	:int;
			
			var textField	:TextField;
			
			var tile		:Quad;
			var back		:Quad;
			
			var position:uint;
			
			const textFormat:TextFormat = new TextFormat(
				INDEX_FONT_NAME, INDEX_FONT_SIZE, INDEX_COLOR, Align.LEFT, Align.TOP);
			
			for each (_questionVO in data) 
			{
				gridX 			= _questionVO.x;
				gridY 			= _questionVO.y;
				qlabel			= Math.abs(_questionVO.id);
				qindex			= _questionVO.index;
				qlength 		= _questionVO.length;
				skipArray		= _questionVO.skip;
				characters		= _questionVO.letters;
				answered		= _questionVO.answered;
				direction 		= _questionVO.direction; // 0 - Horizontal
				horizontal 		= direction ? 1 : 0;
				vertical 		= direction ? 0 : 1;
				
				skipIndex		= skipArray.length > 0 ? int(skipArray.shift()) : -1;
				
				// Ставим номер вопроса только в том случае если он впервые попался
				if(qlabel == label) {
					textField = new TextField(	
						INDEX_WIDTH, 
							INDEX_HEIGHT, 
							String(qlabel), 
							textFormat 
						);
					textField.touchable = false;
					textField.batchable = true;
					
					// Смешаем номер вопроса из угла
					tileX = gridX * TILE_SIZE;
					tileY = gridY * TILE_SIZE;
					tileX += INDEX_OFFSET + TILE_OFFSET;
					tileY += TILE_OFFSET;
					
					textField.x = tileX;
					textField.y = tileY;
					
					_indexiesLayer.addChild(textField);
					
					label++;
				}
				
				counter = 0;
				while(counter < qlength)
				{
					// Это значение с номером вопроса (тайла) в данной ячейке (может быть больше 100 если в ячейке два вопроса)
					anchorGridValue = anchorGrid.getValue(gridX, gridY);
					// Это значение символа в данной ячейке
					gameGridValue 	= gameGrid.getValue(gridX, gridY);
					
					tileX = gridX * TILE_SIZE;
					tileY = gridY * TILE_SIZE;
					
					// Пропускаем тайлы которые могут накладываться друг на друга
					if(skipIndex > -1 && skipIndex == counter) {
						skipIndex = skipArray.length > 0 ? skipArray.shift() : -1;
					} else {
						back = new Quad(TILE_SIZE, TILE_SIZE, TILE_COLOR);
						back.x = tileX;
						back.y = tileY;
						_tilesLayer.addChild(back);
						tile = new Quad(INNER_SIZE, INNER_SIZE, INNER_COLOR);
						tile.x = tileX;
						tile.y = tileY;
						_tilesLayer.addChild(tile);
					}
					
//					if(qindex > 2 && qindex < 12)
//					trace(qlabel, counter, characters[counter]);
					
					character = characters[counter];
					// Если вопрос отвечен и в ячейке еще нету буквы то мы помещаем туда букву
					// Или вставляем букву которая была сохранены при использовании подсказки
					if(answered && gameGridValue == 0 || (character && character != "")) {
							character = String(character).toUpperCase();
							textField = new TextField(	
								TILE_SIZE, 
								TILE_SIZE, 
								character, 
								ANSWER_CHAR_FORMAT
							);
							textField.touchable = false;
							textField.batchable = true;
							textField.x = tileX;
							textField.y = tileY;
							_charactersLayer.addChild(textField);
							
							gameGridValue = character.charCodeAt();
							gameGrid.setValue(gridX, gridY, gameGridValue);
							
							// Также смотрим если в этой ячейке есть другой вопрос и он не отвечен
							// то мы добавляем к этому вопросу букву
							if (anchorGridValue > 0) { 
								tempQVO = data[anchorGridValue - 1];
								if (!tempQVO.answered) {
									position = Math.abs((tempQVO.x - gridX) + (tempQVO.y - gridY));
//									trace(qindex, "HAVE LETTER : ", character, position, "from answered: " + qlabel, tempQVO.letters);
									tempQVO.letters[position] = character;
								}
							}
					} 
					else if (!answered && gameGridValue > 0) {
						// Если вопрос не отвечен и в текущей ячейке есть другой вопрос
						// то смотрим на этот вопрос и если он отвечен берем из него букву и добавляем к текущему вопросу
						// Также если в этой ячейке уже есть буква то бы тоже ее туда ставим
//						trace("anchorGridValue | gameGridValue :", anchorGridValue + "|" + String.fromCharCode(gameGridValue) + " at x,y=", gridX, gridY);
						tempQVO = data[anchorGridValue - 1];
						position = Math.abs((tempQVO.x - gridX) + (tempQVO.y - gridY));
						character = tempQVO.letters[position];
						if (tempQVO && tempQVO.answered || (character && character != "")) {
							_questionVO.letters[counter] = String.fromCharCode(gameGridValue);
							//trace(qlabel, "HAVE LETTER : ", String.fromCharCode(gameGridValue), counter, "from " + questionVO.id);
						}
					}
					
					// Ставим якорек с номером тайла там где уже есть якорь
					anchorGridValue = anchorGridValue > 0 ? anchorGridValue + qindex * 100 : qindex
					anchorGrid.setValue(gridX, gridY, anchorGridValue);
					
					gridX += horizontal;
					gridY += vertical;
					
					counter++;
				}
				if(gridX > gridXMax) gridXMax = gridX;			
				if(gridY > gridYMax) gridYMax = gridY;			
			}
			
			const screenWidth:uint = Application.SCREEN_WIDTH;
			const screenHeight:uint = Application.SCREEN_HEIGHT;
			
			var backXCount:uint = 1;
			var backYCount:uint = 1;
			
			if (_tilesLayer.width < screenWidth) {
				_isHMovePossible = false;
				_positionMinX = (screenWidth - _tilesLayer.width) * 0.5;
				_positionMaxX = _positionMinX;
				this.x = _positionMinX;
				
				backXCount = Math.ceil(_positionMinX / TILE_SIZE);
				_backgroundLayer.x = -backXCount * TILE_SIZE;
				
			} else {
				_isHMovePossible = true;
				_positionMaxX = TILE_SIZE;
				_positionMinX = -_tilesLayer.width + screenWidth- TILE_SIZE;
				this.x = TILE_SIZE;
				_backgroundLayer.x -= TILE_SIZE;
			}
			
			if (_tilesLayer.height < screenHeight) {
				_isVMovePossible = false;
				_positionMinY = (screenHeight - _tilesLayer.height) * 0.5;
				_positionMaxY = _positionMinY;
				this.y = _positionMinY;
				backYCount += Math.ceil(_positionMinY / TILE_SIZE);
				_backgroundLayer.y = -backYCount * TILE_SIZE;
			} else {
				_isVMovePossible = true;
				_positionMaxY = TILE_SIZE;
				_positionMinY = -_tilesLayer.height + screenHeight - TILE_SIZE;
				this.y = TILE_SIZE;
				_backgroundLayer.y -= TILE_SIZE;
			}
			
			backXCount = backXCount * 2 + gridXMax;
			backYCount = backYCount * 2 + gridYMax;
			gridX = backXCount;
			_backgroundLayer.addMesh(new Quad(screenWidth, screenHeight, Colors.WHITE_F1));
			while(gridX--){
				gridY = backYCount;
				while(gridY--){
					tileX = gridX * TILE_SIZE;
					tileY = gridY * TILE_SIZE;
					tile = new Quad(INNER_SIZE, INNER_SIZE, BGR_COLOR);
					tile.x = tileX;
					tile.y = tileY;
					_backgroundLayer.addMesh(tile);
				}
			}
			
			trace("_positionMaxX = " + _positionMaxX);
			trace("_positionMaxY = " + _positionMaxY);
			
			_backgroundLayer.touchable = true;
			
			this.addChild(_backgroundLayer);
			this.addChild(_tilesLayer);
			this.addChild(_indexiesLayer);
			this.addChild(_charactersLayer);
			
		}
		//==================================================================================================
		public final function touchstart(position:Point):void { 
		//==================================================================================================
			_touchStartPoint.x = this.x;
			_touchStartPoint.y = this.y;
			_isTapPossible = true;
		}
		//==================================================================================================
		public final function touchmove(delta:Point):void {
		//==================================================================================================
			_position = this.transformationMatrix.transformPoint(delta);
			if(_isVMovePossible) {
				if(_position.y < _positionMinY) 		_position.y = _positionMinY;
				else if (_position.y > _positionMaxY) 	_position.y = _positionMaxY;
				this.y = _position.y;
			}
			if(_isHMovePossible) {
				if(_position.x < _positionMinX)			_position.x = _positionMinX;
				else if(_position.x > _positionMaxX) 	_position.x = _positionMaxX;
				this.x = _position.x;
			}
			_isTapPossible = _isTapPossible && Point.distance(_position, _touchStartPoint) < TAP_ACCURACY;
		}
		//==================================================================================================
		public final function touchend(position:Point):Boolean { 
		//==================================================================================================
			_touchEndPoint.x = this.x;
			_touchEndPoint.y = this.y;
			trace("touchend", _touchEndPoint);
			// Смотрим не привышает ли смещение допустимого для нажатия значения
			if (!_isTapPossible) return false;
			
			_position = position;
			tileX = _position.x;
			tileY = _position.y;
			
			// Смотрим не отрицательне ли положение тайта
			if (CheckTilePositionNegative()) return false;
			
			gridX = Math.floor(tileX / TILE_SIZE);
			gridY = Math.floor(tileY / TILE_SIZE);
			
			// Смотрим какое значение в ячейки куда мы нажали, не пустой ли это тайл
			tileTapIndex = anchorGrid.getValue(gridX, gridY)
			if (CheckTileEmpty(tileTapIndex)) return false; 
			
			_position.setTo(gridX * TILE_SIZE, gridY * TILE_SIZE)
			
			trace("> grid: " + gridX + "|" + gridY + " ; tileIndex: " + tileTapIndex);
			return true; 
		}	
		
		//==================================================================================================
		public final function tap():void { 
		//==================================================================================================
			this.dispatchEventWith(Events.TAP_HAPPEND_ONGAME, false, { index: tileTapIndex, position: this.localToGlobal(_position) });
		}
		
		//==================================================================================================
		private final function ResetStageScale():void {
		//==================================================================================================
			this.transformationMatrix.d = this.transformationMatrix.a = 1;
		}
		
		
		//==================================================================================================
		private function CheckTapNotPossible():Boolean {
		//==================================================================================================
			var touchDistance:Number = Point.distance(_touchEndPoint, _touchStartPoint);
			var result:Boolean = touchDistance > TAP_ACCURACY;
			return result;
		}
		
		//==================================================================================================
		private function CheckTilePositionNegative():Boolean {
		//==================================================================================================
			return (tileX < 0 || tileY < 0);
		}
		
		//==================================================================================================
		private function CheckTileEmpty(index:int):Boolean {
		//==================================================================================================
			return index == 0;
		}
	}
}
