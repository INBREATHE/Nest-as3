/**
 * ...
 * @author Vladimir Minkin
 */

package app.model.proxy {
	import nest.interfaces.ILocalize;
	import nest.patterns.proxy.Proxy;
	import nest.utils.FileUtils;
	
	public class DataProxy extends Proxy implements ILocalize
	{
		private const 
			PATH	: Array = ["gameres/data/","language","/", "filename"]
		,	LEVEL	: Array = ["0_type", "/", "2_bundle", "/", "4_level", ".pwl"]		
		,	DATA	: String = "data.pwl"
		;
		
		private var 
			type			: XML
		,	bundle			: XML
		,	level			: XML
		,	levelData		: XML
		;
		
		public function DataProxy(language:String = "ru") {
			PATH[3] = DATA;
		}
		
		public function setupLanguage(value:String):void {
			PATH[1] = value;
			PATH[3] = DATA;
			this.setData(new XML(FileUtils.readBytesFromFile(PATH.join(""))));
		}
		
		public function getTypes():XMLList { return XMLList(list.type); }
		
		public function getBundlesForTypeIndex( index:uint ):XMLList {
			type = XML(list.type[index]);
			return XMLList(type.bundle);
		}
		
		public function getBundlesForTypeName( typeName:String ):XMLList {
			type = XMLList(list.type.(@name == typeName))[0];
			return XMLList(type.bundle);
		}
		
		public function getLevelsForBundle( index:uint ):XMLList {
			bundle = XMLList(type.bundle[index])[0];
			return XMLList(bundle.level);
		}
		
		public function getTypeStarterTree():Array {
			var result:Array = type.@start.split(",");
			result.forEach(function(item:String, index:uint, arr:Array):void {
				arr[index] = int(item);
			});
			trace("getTypeStarterTree", result);
			return result;
		}
		
		public function getGameDataForLevel(index:uint):XML {
			level = XMLList(bundle.level[index])[0];
			LEVEL[0] = String(type.@name);
			LEVEL[2] = String(bundle.@name);
			LEVEL[4] = String(level.@name);
			PATH[3] = LEVEL.join("");
			trace("Load game data from:", PATH.join(""));
			levelData = new XMLList(FileUtils.readStringFromFile(PATH.join(""))).children();
			return levelData;
		}
		
		public function getCurrentLevelAttribute( name:String ):String {
			return String(level.@[name])
		}
		
		public function get currentLevelLength():uint {
			var result:uint = uint(levelData.length());
			return result;
		}
		
		private function get list():XML { return this.data as XML; }
	}
}
