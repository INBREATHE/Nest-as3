/*
 NEST AS3 SingleCore
 Copyright (c) 2016 Vladimir Minkin <vladimir.minkin@gmail.com>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package nest.patterns.observer
{
import nest.interfaces.IFacade;
import nest.interfaces.INotifier;
import nest.patterns.facade.Facade;

public class Notifier implements INotifier
{
	public function send( notificationName:String, body:Object = null, type:String = null ):void {
		facade.sendNotification( new Notification( notificationName, body, type ) );
	}

	protected var facade:IFacade = Facade.getInstance();

	public function exec( commandName:String, body:Object = null, type:String = null ):* {
		return facade.executeCommand( new Notification( commandName, body, type ) );
	}

	public function commandExist( value:String):Boolean { return facade.hasCommand( value ); }
	public function getCurrentLanguage():String { return Facade(facade).currentLanguage; }
}
}