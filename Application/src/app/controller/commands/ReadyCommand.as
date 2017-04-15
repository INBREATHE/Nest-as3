package app.controller.commands
{
import consts.Screens;

import nest.entities.screen.ScreenCommand;
import nest.patterns.command.SimpleCommand;
	
public final class ReadyCommand extends SimpleCommand
{
	override public function execute(body:Object, type:String):void
	{
		this.exec( ScreenCommand.CHANGE, null, Screens.MAIN );
	}
}
}