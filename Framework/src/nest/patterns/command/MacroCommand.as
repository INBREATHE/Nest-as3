/*
 NEST AS3 SingleCore
 Copyright (c) 2016 Vladimir Minkin <vladimir.minkin@gmail.com>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package nest.patterns.command
{
import nest.injector.Injector;
import nest.interfaces.ICommand;
import nest.interfaces.INotifier;
import nest.patterns.observer.Notifier;

public class MacroCommand extends Notifier implements ICommand, INotifier
{
	private var _subCommands:Vector.<Class> = new Vector.<Class>();

	public function MacroCommand() { initializeMacroCommand(); }

	protected function initializeMacroCommand():void { }

	protected function addSubCommand( commandClassRef:Class ): void {
		Injector.mapTarget(commandClassRef);
		_subCommands.push(commandClassRef);
	}
	protected function addSubCommands(classes:Vector.<Class>): void {
		Injector.mapTargets(classes);
		_subCommands = _subCommands.concat(classes);
	}

	public final function execute( body:Object, type:String ) : void {
		var commandClassRef : Class;
		var commandInstance : ICommand;
		while (_subCommands.length > 0) {
			commandClassRef = _subCommands.shift() as Class;
			commandInstance = new commandClassRef();
			commandInstance.execute( body, type);
			Injector.unmapTarget(commandClassRef);
		}
		commandClassRef = null;
		commandInstance = null;
	}
}
}