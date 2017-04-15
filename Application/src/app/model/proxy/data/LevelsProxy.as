package app.model.proxy.data
{
	import app.model.vo.data.LevelVO;
	
	import consts.Specials;
	import consts.Tables;
	
	import nest.interfaces.IProxy;
	import nest.patterns.proxy.Proxy;
	import nest.services.database.DatabaseProxy;
	
	public class LevelsProxy extends Proxy implements IProxy
	{
		private var _database			: DatabaseProxy;
		private var _currentLevel		: LevelVO;
		
		override public function onRegister():void {
			_database = facade.retrieveProxy(DatabaseProxy) as DatabaseProxy;
		}
		
		public function init(count:uint):void { 
			this.setData(new Array(count));
		}
		
		public function resetCurrentLevel():void {
			_currentLevel = null;
		}
		
		//==================================================================================================
		// DATABASE INTERACTIONS
		//==================================================================================================
		public function selectLevel(levelName:String):LevelVO {
			return LevelVO(_database.select(Tables.LEVELS, Tables.GetCriteriaFor_Level(levelName), LevelVO));
		}
		
		public function storeLevelAt(index:uint, value:LevelVO, initialize:Boolean = false):void {
			if(initialize) _database.store(Tables.LEVELS, JSON.stringify(value));
			levels[index] = value;
		}
		public function updateLevel(value:LevelVO, data:Object):void {
			for (var key:String in data) value[key] = data[key];
			_database.update(Tables.LEVELS, Tables.GetCriteriaFor_Level(value.name), data);
		}
		//==================================================================================================
		
		public function getLevelsByIndex(value:uint):LevelVO {
			const level:LevelVO = LevelVO((data as Array)[value]);
			return level;
		}

		//==================================================================================================
		public function get currentLevel():LevelVO { return _currentLevel; }
		public function set currentLevel(value:LevelVO):void { _currentLevel = value; }
		public function get currentLevelName():String { return _currentLevel != null ? _currentLevel.name : ""; }
		
		public function get isNextLevelAvailableForCurrentLevel():Boolean {
			const nextLID:uint = _currentLevel.lid + 1;
			const nextLevel:LevelVO = getLevelsByIndex(nextLID);
			return nextLID < levels.length && !nextLevel.locked;
		}
		public function get isPrevLevelAvailableForCurrentLevel():Boolean {	return _currentLevel.lid > 0; }
		//==================================================================================================

		private function get levels():Array { return data as Array; }
		
	}
}
