package app.view.components.elements
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import consts.Colors;
	import consts.Fonts;
	
	import nest.entities.application.Application;
	
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.text.TextFormat;
	
	/**
	 * ...
	 * @author Vladimir Minkin
	 */
	public class HudHeader extends Sprite 
	{
		private var timeTF:TextField;
		private var time:String;
		private var minutes:Number;
		private var hours:Number;
		
		public function HudHeader() 
		{
			super();
			
			const scalefactor:Number = Application.SCALEFACTOR;
			const bw:Number = Application.SCREEN_WIDTH;
			const bh:Number = 50 * scalefactor;
			
			const date:Date = new Date();
			hours = date.hours;
			minutes = date.minutes;
			time = getTimeString();
			timeTF = new TextField(bh, bh, time);
			const format:TextFormat = timeTF.format;
			format.font = Fonts.LATO_REGULAR;
			format.size = 12 * scalefactor;
			format.color = Colors.HUD_HEADER_TIME;
			timeTF.x = (bw - timeTF.width) * 0.5;
			
			this.addChild(timeTF);
			
			const timer:Timer = new Timer(60000.0);
			timer.addEventListener(TimerEvent.TIMER, function ():void 
			{
				minutes += 1;
				if (minutes == 60) {
					minutes = 0;
					hours = hours == 12 ? 1 : hours + 1;
				}
				time = getTimeString();
				timeTF.text = time;
			})
			timer.start();
		}
		
		private function getTimeString():String
		{
			return String(hours < 10 ? "0" + hours : hours) + " : " + (minutes < 10 ? "0" + minutes : minutes);
		}
	}
}
