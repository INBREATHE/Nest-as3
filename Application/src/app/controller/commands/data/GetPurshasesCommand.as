/**
 * ...
 * @author Vladimir Minkin
 */

package app.controller.commands.data {
	
	import nest.services.database.DatabaseProxy;
	import app.model.proxy.UserProxy;
	
	import consts.notifications.DataNotifications;
	
	import nest.interfaces.ICommand;
	import nest.patterns.command.SimpleCommand;
	
	public class GetPurshasesCommand extends SimpleCommand implements ICommand 
	{
		[Inject] public var userProxy			: UserProxy;
		[Inject] public var databaseProxy		: DatabaseProxy;
		
		override public function execute( body:Object, type:String ):void 
		{
			const language	: String = this.getCurrentLanguage();
			send( DataNotifications.TAKE_PURSHASES );
		}
	}
}
