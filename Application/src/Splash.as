package
{
import flash.display.DisplayObject;
import flash.display.Graphics;
import flash.display.Sprite;
import flash.events.Event;
import flash.system.Capabilities;

public class Splash extends Sprite
{
	private var
		that	: Splash
	,	logo	: DisplayObject
	;

	private const
		ANIMATION_IN		: Number = 2
	,	ANIMATION_BACK		: Number = 1
	;

//		private var
//			_outroTween			: Tween
//		,	timers				: uint
//		;

	public function Splash(background:uint) {
		that = this;

		DrawBackground(background);

		this.addEventListener(Event.ADDED_TO_STAGE, AddedToStage);

		const splashScreen:SplashScreen = new SplashScreen();
		logo = this.addChild(splashScreen.getChildAt(0));

		this.addEventListener(Event.ADDED_TO_STAGE, Handle_AddedToStage)


//			const tween8:Tween = new Tween(this, ANIMATION_BACK);
//
//			tween8.fadeTo(0);
//			tween8.delay = 1;
//			tween8.onComplete = function():void {
//				Starling.juggler.purge();
//				that.parent.removeChild(that);
//				that = null;
//				trace((getTimer() - timers) / 1000 + "sec");
//			};
//
//			_outroTween = tween8;
	}

	private function Handle_AddedToStage(event:Event):void {
		logo.x = (stage.stageWidth - logo.width) * 0.5;
		logo.y = (stage.stageHeight - logo.height) * 0.5;
	}

	protected function AddedToStage(event:Event):void {
		this.removeEventListener(Event.ADDED_TO_STAGE, AddedToStage);
//			timers = getTimer();
	}

	public function hide():void {
//		Starling.juggler.add(_outroTween);
		this.parent.removeChild(this);
	}

	private function DrawBackground(color:uint):void {
		const g:Graphics = this.graphics;
		g.beginFill(color);
		g.drawRect(0, 0, Capabilities.screenResolutionX, Capabilities.screenResolutionY);
		g.endFill();
	}
}
}