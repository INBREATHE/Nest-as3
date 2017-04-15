/**
 * ...
 * @author Vladimir Minkin
 */

package app.view.mediators.elements
{
	import app.view.components.elements.HudHeader;
	
	import consts.notifications.HudHeaderNotification;
	
	import nest.entities.application.ApplicationNotification;
	import nest.interfaces.IMediator;
	import nest.interfaces.INotification;
	import nest.patterns.mediator.Mediator;
	
	import starling.display.DisplayObject;

	/**
	 * A Mediator for interacting with the ...
	 */
	public class HudHeaderMediator extends Mediator implements IMediator 
	{
		public function HudHeaderMediator() { super( new HudHeader() ); }
		
        override public function onRegister():void {
			this.send( ApplicationNotification.ADD_ELEMENT, this.viewComponent );
		}
		
		override public function listNotificationInterests():Vector.<String> {
			
			return new <String>[
				HudHeaderNotification.SHOW, 
				HudHeaderNotification.HIDE
			];
		}
		
		override public function handleNotification( note:INotification ):void {
			switch ( note.getName() ) 
			{           
				case HudHeaderNotification.SHOW: 
					if(DisplayObject(this.viewComponent).parent == null)
						this.send( ApplicationNotification.ADD_ELEMENT, this.viewComponent );
					break;
				case HudHeaderNotification.HIDE:
					this.send( ApplicationNotification.REMOVE_ELEMENT, this.viewComponent );
					break;
			}
		}
	}
}
