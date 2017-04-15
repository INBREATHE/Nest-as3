/*
 NEST AS3 SingleCore
 Copyright (c) 2016 Vladimir Minkin <vladimir.minkin@gmail.com>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package nest.services.server.commands
{
import nest.patterns.command.SimpleCommand;
import nest.services.server.entities.IServerData;

public final class ServerResponceCommand extends SimpleCommand
{
	//==================================================================================================
	override public function execute( body:Object, type:String ) : void {
	//==================================================================================================
		trace("> Nest -> ServerResponceCommand");
		const responce	: IServerData = body as IServerData;
		const callback	: Object = responce.callback;
		const data		: Object = responce.data;

		if(callback is Function) callback.call(null, data);
		else {
			if(this.commandExist(String(callback)))
					this.exec(String(callback), data);
			else 	this.send(String(callback), data);
		}
	}
}
}