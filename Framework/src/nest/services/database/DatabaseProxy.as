/*
 NEST AS3 SingleCore
 Copyright (c) 2016 Vladimir Minkin <vladimir.minkin@gmail.com>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package nest.services.database
{
import flash.utils.Dictionary;

import nest.interfaces.ILocalize;
import nest.interfaces.IProxy;
import nest.patterns.proxy.Proxy;

/**
 * C:\Users\DQvsRA\AppData\Roaming\[App Identifier]\Local Store\
 * @author Vladimir Minkin
 */

/*
 *
	Using encryption with SQL databases
	info: http://help.adobe.com/en_US/as3/dev/WS8AFC5E35-DC79-4082-9AD4-DE1A2B41DAAF.html
*/

public class DatabaseProxy extends Proxy implements IProxy, ILocalize
{
	private const _events : Dictionary = new Dictionary();

	public function get dbExist():Boolean { return _dbService.dbExist; }

	//==================================================================================================
	public function create(tables:Dictionary):void {
	//==================================================================================================
		_dbService.create(tables);
	}

	//==================================================================================================
	public function retrieve(query:String, classRef:Class = null, all:Boolean = false, languageDependent:Boolean = true):Object {
	//==================================================================================================
		return _dbService.retrieve(query, classRef, all, languageDependent);
	}

	//==================================================================================================
	public function select(table:String, critiria:String, classRef:Class, all:Boolean = false, languageDependent:Boolean = true):Object {
	//==================================================================================================
		return _dbService.select(table, critiria, classRef, all, languageDependent);
	}

	//==================================================================================================
	public function count(table:String, critiria:String, languageDependent:Boolean = true):uint {
	//==================================================================================================
		return _dbService.count(table, critiria, languageDependent);
	}

	//==================================================================================================
	public function store(table:String, data:Object):void {
	//==================================================================================================
		_dbService.store(table, data);
	}

	//==================================================================================================
	public function update(table:String, criteria:String, data:Object, languageDependent:Boolean = true):void {
	//==================================================================================================
		_dbService.update(table, criteria, data, languageDependent);
	}

	//==================================================================================================
	public function remove(table:String, criteria:String, languageDependent:Boolean = true):void {
	//==================================================================================================
		_dbService.remove(table, criteria, languageDependent);
	}

	//==================================================================================================
	public function setupLanguage(value:String):void {
	//==================================================================================================
		_dbService.language = value;
	}

	//==================================================================================================
	public function listen(eventType:String, table:String, classRef:Class, callback:Function):void {
	//==================================================================================================
		_dbService.listen(eventType, table, classRef, callback);
	}

	//==================================================================================================
	override public function onRegister():void {
	//==================================================================================================

	}

	public function DatabaseProxy() {
		super(DatabaseService.getInstance());
	}

	private function get _dbService():DatabaseService { return DatabaseService(data); }
}
}
