package app.controller.commands {
	
import app.controller.commands.prepare.PrepareBeginCommand;
import app.controller.commands.prepare.PrepareCompleteCommand;
import app.controller.commands.prepare.PrepareControllerCommand;
import app.controller.commands.prepare.PrepareLocalizeCommand;
import app.controller.commands.prepare.PrepareModelCommand;
import app.controller.commands.prepare.PrepareServicesCommand;
import app.controller.commands.prepare.PrepareUserCommand;
import app.controller.commands.prepare.PrepareViewCommand;

import nest.interfaces.ICommand;
import nest.patterns.command.AsyncMacroCommand;

public final class StartupCommand extends AsyncMacroCommand implements ICommand
{
	override protected function initializeAsyncMacroCommand():void
	{
		this.addSubCommands(new <Class>[
				PrepareBeginCommand			// SimpleCommand
			,	PrepareServicesCommand		// AsyncCommand
			,	PrepareModelCommand			// AsyncCommand
			,	PrepareControllerCommand	// AsyncCommand
			,	PrepareLocalizeCommand		// SimpleCommand
			,	PrepareViewCommand			// AsyncCommand

			,	PrepareUserCommand			// SimpleCommand
			,	PrepareCompleteCommand		// SimpleCommand
		]);
	}
}
}
