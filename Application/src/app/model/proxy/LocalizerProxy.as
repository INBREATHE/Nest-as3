package app.model.proxy
{
	import nest.interfaces.ILocalize;
	import nest.patterns.proxy.Proxy;
	import nest.utils.FileUtils;
	
	public class LocalizerProxy extends Proxy implements ILocalize 
	{
		private static const 
			PATH		: Array = ["gameres/locale/","1_language","/", "3_filename"]
		,	FILENAME	: String = "locale.xml"
		,	INFO_TITLE	: String = "_info_title"
		,	INFO_TEXT	: String = "_info_text"
		,	LANGUAGES	: Object = {
				ru : "Русский"
			,	en : "English"
			,	current : ""
			}
		;
			
		public function LocalizerProxy() {
			PATH[3] = FILENAME;
		}
		
		public function setupLanguage(value:String):void {
			const lng:String = value;
			PATH[1] = lng;
			PATH[3] = FILENAME;
			LANGUAGES.current = lng;
			this.setData(new XML(FileUtils.readStringFromFile(PATH.join(""))));
		}

		public function get currentLanguageName():String { return LANGUAGES[this.getCurrentLanguage()]; };
		
		public function get languages():Object {
			return LANGUAGES;
		}
		
		public function getLocaleForPopup(name:String):XMLList {
			return popups[name];
		}
		
		public function getLocaleForScreen(name:String):XMLList {
			return screens[name];
		}
		
		public function getTypeTitleByName(type:String):String {
			var result:String = strings.(@key == type).@value;
			return result;
		}

		public function getStringByKey(key:String):String {
			var result:String = strings.(@key == key).@value;
			return result;
		}
		
		public function getInfoPopupDescription(value:String):Object {
			const loco		: XMLList = strings;
			const titleKey	: String = value + INFO_TITLE;
			const textKey	: String = value + INFO_TEXT;
			const result	: Object = {
				title: String(loco.(@key == titleKey).@value),
				text: String(loco.(@key == textKey).@value)
			};
			return result;
		}

		private function get strings():XMLList { return XMLList(data.str); }
		private function get popups():XMLList { return XMLList(data.popups); }
		private function get screens():XMLList { return XMLList(data.screens); }
	}
}
