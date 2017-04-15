/**
 * ...
 * @author Vladimir Minkin
 */

package app.model.proxy 
{
	import flash.data.EncryptedLocalStore;
	import flash.utils.ByteArray;
	
	import app.model.vo.SettingsVO;
	
	import nest.interfaces.IProxy;
	import nest.patterns.proxy.Proxy;
	
	/*
	 * 
		Encrypted local storage
		info: http://help.adobe.com/en_US/as3/dev/WS5b3ccc516d4fbf351e63e3d118666ade46-7e31.html
		docs: http://help.adobe.com/en_US/FlashPlatform/reference/actionscript/3/flash/data/EncryptedLocalStore.html
	*/
	
	public class SettingsProxy extends Proxy implements IProxy 
	{
		public function SettingsProxy() {
			const byteArray:ByteArray = EncryptedLocalStore.getItem("settings");
			const settings:SettingsVO = byteArray != null ?  SettingsVO(byteArray.readObject()) : new SettingsVO();
			super(settings); 
		} 
				
		public function saveSettings():void
		{
			const bytes:ByteArray = new ByteArray(); 
			bytes.writeObject(settings); 
			EncryptedLocalStore.setItem("settings", bytes, false); 
		}
		
		public function get settings():SettingsVO { return data as SettingsVO; }
	}
}
