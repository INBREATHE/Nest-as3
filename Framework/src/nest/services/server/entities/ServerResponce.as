/*
 NEST AS3 SingleCore
 Copyright (c) 2016 Vladimir Minkin <vladimir.minkin@gmail.com>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package nest.services.server.entities
{
import flash.events.Event;
import nest.services.server.consts.ServerStatus;

public final class ServerResponce extends Event implements IServerData
{
	public static const COMPLETE:String = "nest_serverservice_server_respond_complete";

	private var _data:Object;
	public function get data():Object { return _data; }

	private var _callback:Object;
	public function get callback():Object {	return _callback; }

	public function ServerResponce(callback:Object, data:Object)
	{
		this._callback = callback;
		this._data = data;
		super(COMPLETE, false, false);
	}

	public static function NO_NETWORK(callback:Object):IServerData {
		return new ServerResponce(callback, { status: ServerStatus.ERROR, message: "No network" });
	}
}
}