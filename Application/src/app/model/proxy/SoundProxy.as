/**
 * ...
 * @author Vladimir Minkin
 */

package app.model.proxy 
{
	import nest.interfaces.IProxy;
	import nest.patterns.proxy.Proxy;
	
	import treefortress.sound.SoundManager;
	
	public class SoundProxy extends Proxy implements IProxy 
	{
		private var soundManager:SoundManager = new SoundManager();
		public function SoundProxy() { super(); }
		
		override public function onRegister():void {
//			soundManager.addSound(Sounds.TICK, 		new TickSoundClass as Sound);
		}
		
		public function playSound(name:String, start:uint = 0, volume:Number = 1):void {
			if(!soundManager.getSound(name).isPlaying)
			soundManager.play(name, volume, start);
		}
		
		public function playLoopSound(name:String, volume:Number, fade:Boolean = false):void {
			if(fade) soundManager.fadeFrom(name, 0, 1, 4000);
			soundManager.playLoop(name, volume);
		}
		
		public function stopAllSounds():void {
			
		}
	}
	
}
