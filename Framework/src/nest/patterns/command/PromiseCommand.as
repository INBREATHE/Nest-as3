/*
 NEST AS3 SingleCore
 Copyright (c) 2016 Vladimir Minkin <vladimir.minkin@gmail.com>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package nest.patterns.command
{
import nest.interfaces.ICommand;
import nest.patterns.observer.Notifier;
import nest.promise.Deferred;
import nest.promise.Promise;

public class PromiseCommand extends Notifier implements ICommand
{
	protected const deffered:Deferred = new Deferred();
	public function execute( body:Object, type:String ) : void { }
	public function get promise():Promise { return deffered.promise; }
}
}