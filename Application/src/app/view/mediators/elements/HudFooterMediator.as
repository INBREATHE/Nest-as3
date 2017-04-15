/**
 * ...
 * @author Vladimir Minkin
 */

package app.view.mediators.elements 
{
	import app.view.components.elements.HudFooter;
	
	import consts.Screens;
	import consts.events.Events;
	import consts.notifications.HudFooterNotification;
	
	import nest.entities.application.ApplicationNotification;
	import nest.entities.screen.ScreenCommand;
	import nest.interfaces.IMediator;
	import nest.interfaces.INotification;
	import nest.patterns.mediator.Mediator;
	import nest.patterns.observer.NFunction;
	
	import starling.display.DisplayObject;
	import starling.events.Event;
	
	/**
	 * A Mediator for interacting with the ...
	 */
	public class HudFooterMediator extends Mediator implements IMediator 
	{
		static private const 
			FOOTER_METHOD__SET_SCORE		: String = "setScore"
		,	FOOTER_METHOD__ADD_SCORE		: String = "addScore"
		;
		
		public function HudFooterMediator() { super( new HudFooter() ); }
		
		override public function onRegister():void {
			this.send( ApplicationNotification.ADD_ELEMENT, this.viewComponent );
			//footer.addEventListener(Events.TAP_HAPPEND_USER, HandleUserButtonEvent)
			//footer.addEventListener(Events.TAP_HAPPEND_MARKET, HandleMarketButtonEvent)
		}

		//==================================================================================================
		private function HandleMarketButtonEvent(e:Event):void {
		//==================================================================================================
			HideFooter();
			this.exec( ScreenCommand.CHANGE, null, Screens.MARKET );
		}
		
		//==================================================================================================
		private function HandleUserButtonEvent(e:Event):void {
		//==================================================================================================
//			trace("HandleUserButtonEvent");
			HideFooter();
			this.exec( ScreenCommand.CHANGE, null, Screens.USER );
			
		}
        
		//==================================================================================================
		override public function listNotificationInterests():Vector.<String> {
		//==================================================================================================
			return new <String>[
				HudFooterNotification.HIDE
			,	HudFooterNotification.SHOW
			];
		}
		
		//==================================================================================================
		override public function listNotificationsFunctions():Vector.<NFunction> {
		//==================================================================================================
			return new <NFunction>[
				new NFunction( 	HudFooterNotification.SET_SCORE, FOOTER_METHOD__SET_SCORE )
			,	new NFunction( 	HudFooterNotification.ADD_SCORE, FOOTER_METHOD__ADD_SCORE )
			];
		}
		
		//==================================================================================================
		override public function handleNotification( note:INotification ):void { 
		//==================================================================================================
			var name:String = note.getName();
			switch ( name ) 
			{           
				case HudFooterNotification.HIDE:
					HideFooter();
					break;	
				case HudFooterNotification.SHOW:
					ShowFooter();
					break;
			}
		}
		
		//==================================================================================================
		private function ShowFooter():void {
		//==================================================================================================
			if(DisplayObject(this.viewComponent).parent == null)
				this.send( ApplicationNotification.ADD_ELEMENT, footer);
			footer.show();
		}
		
		//==================================================================================================
		private function HideFooter():void {
		//==================================================================================================
			var Send:Function = this.send;
			footer.hide(function():void{
				Send( ApplicationNotification.REMOVE_ELEMENT, footer)
			});
		}
		
		private function get footer():HudFooter {
			return HudFooter(this.viewComponent);
		}
	}
}
