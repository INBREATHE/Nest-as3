/*
 NEST AS3 SingleCore
 Copyright (c) 2016 Vladimir Minkin <vladimir.minkin@gmail.com>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package nest.patterns.command
{
import nest.interfaces.ICommand;
import nest.patterns.observer.Notifier;

public class SimpleCommand extends Notifier implements ICommand
{
	public function execute( body:Object, type:String ) : void { }
}
}