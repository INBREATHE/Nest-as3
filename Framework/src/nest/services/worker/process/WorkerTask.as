/*
 NEST AS3 SingleCore
 Copyright (c) 2016 Vladimir Minkin <vladimir.minkin@gmail.com>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package nest.services.worker.process
{

public final class WorkerTask
{
	public function WorkerTask(id:int, data:Object = null)
	{
		this._data = data;
		this._id = id;
	}

	public static const
		READY 			: int = 0
	,	SYNC_DB 		: int = 10
	,	SIGNAL	 		: int = 11
	,	MESSAGE	 		: int = 12
	,	REQUEST 		: int = 13
	,	PROGRESS 		: int = 14
	,	COMPLETE 		: int = 15
	,	TERMINATE 		: int = 16
	;

	private var _id:int;
	private var _data:Object;

	public function get id():int { return _id; }
	public function get data():Object { return _data; }
}
}

