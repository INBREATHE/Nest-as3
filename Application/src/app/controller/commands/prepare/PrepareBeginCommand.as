package app.controller.commands.prepare {
	
	import nest.entities.application.ApplicationNotification;
	import nest.interfaces.ICommand;
	import nest.patterns.command.SimpleCommand;
	
	public class PrepareBeginCommand extends SimpleCommand implements ICommand
	{
		override public function execute( body:Object, type:String ):void 
		{
			this.send( ApplicationNotification.PREPARE );
		}
	}
}
