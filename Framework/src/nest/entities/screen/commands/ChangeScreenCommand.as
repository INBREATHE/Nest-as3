/**
 * ...
 * @author Vladimir Minkin
 */

package nest.entities.screen.commands
{
	import nest.entities.application.ApplicationNotification;
	import nest.entities.screen.Screen;
	import nest.entities.screen.ScreenCache;
	import nest.entities.screen.ScreenMediator;
	import nest.entities.screen.ScreensProxy;
	import nest.interfaces.ICommand;
	import nest.patterns.command.SimpleCommand;

	public class ChangeScreenCommand extends SimpleCommand implements ICommand
	{
		[Inject] public var screensProxy:ScreensProxy;
		override public function execute( screenData:Object, screenName:String ):void
		{
			var goPrevious		: Boolean			= screenName == Screen.PREVIOUS;
			var currentScreen 	: ScreenCache 		= screensProxy.currentScreen;
			var targetScreen	: ScreenCache 		= goPrevious ? currentScreen.previousScreen : screensProxy.getCacheByScreenName(screenName);
			var screenMediator	: ScreenMediator 	= facade.retrieveMediator(targetScreen.mediatorName) as ScreenMediator;

			if(currentScreen) {
				if(!goPrevious && targetScreen.previousScreen == null)	targetScreen.previousScreen = currentScreen;
				else currentScreen.previousScreen = null;
				
				ScreenMediator(facade.retrieveMediator(currentScreen.mediatorName)).onLeave();
				this.send( ApplicationNotification.HIDE_SCREEN, currentScreen.screen, goPrevious ? "" : null ); 
			}
			
			screensProxy.currentScreen = targetScreen;
			
			if(goPrevious) screenMediator.onReturn();
			else screenMediator.onPrepare(screenData);
		}
	}
}
