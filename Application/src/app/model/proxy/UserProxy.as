package app.model.proxy
{
import app.model.vo.UserVO;

import consts.Tables;

import nest.interfaces.ILocalize;
import nest.patterns.proxy.Proxy;
import nest.services.database.DatabaseProxy;
import nest.services.database.DatabaseQuery;

public class UserProxy extends Proxy implements ILocalize 
{
	private var _database:DatabaseProxy;
	
	override public function onRegister():void {
		_database = facade.retrieveProxy(DatabaseProxy) as DatabaseProxy;
		this.setUser(_database.select(Tables.USER, DatabaseQuery.RowID(1), UserVO, false, false) as UserVO);
	}
	
	public function setUser(value:UserVO):void { 
		if(user == null && value) _database.store(Tables.USER, value);
		setData(value);
	}
	public function getUser():UserVO { return user; }
	
	//==================================================================================================
	public function setupLanguage(value:String):void {
	//==================================================================================================
		if(user) user.lng = value;
	}
	
	public function getUserLevels():Array {
		const lng:String = this.getCurrentLanguage();
		var result:Array = user.gametree[lng] as Array;
		if(result == null) result = user.gametree[lng] = [];
		return result;
	}

	public function addLevelToGameTree(lid:uint):void {
		(this.getUserLevels() as Array).push(lid);
		UpdateUserParam({ gametree: user.gametree });
	}

	public function set userScore(value:int):void {
		user.score = value;
		UpdateUserParam({ score:value });
	}
	
	public function set userSocial(value:Object):void {
		user.social = value;
		UpdateUserParam({ social:value });
	}
	
	public function set socialToken(value:String):void { 
		user.token = value; 
		UpdateUserParam({ token:value });
	}
	
	public function set userRegistered(value:Boolean):void {
		user.registered = value;
		UpdateUserParam({ registered:value });
	}
	
	public function set userLastActiveMailID(count:uint):void {
		user.mails[this.getCurrentLanguage()] = count;
		UpdateUserParam({ mails:user.mails });
	}
	
	public function get userLastActiveMailID():uint {
		const mails:Object = userLastMail;
		if(!mails.hasOwnProperty(String(this.getCurrentLanguage()))) {
			user.mails[this.getCurrentLanguage()] = 0;
			return 0;
		} else return mails[this.getCurrentLanguage()]
	}
	
	public function get socialToken()	: String 	{ return user.token; 	}
	public function get userLastMail()	: Object 	{ return user.mails;	}
	public function get userUUID()		: String 	{ return user.uuid; 	}
	public function get userGameTree()	: Object 	{ return user.gametree; }
	public function get userScore()		: int 		{ return user.score; 	}
	public function get userPlayTime()	: int 		{ return user.playtime; }
	public function get userRegistered(): Boolean 	{ return user.registered; }

	public function get userSocialNetwork():String {
		const social:Object = user.social;
		return social.sn;
	}

	private function get user():UserVO { return UserVO(data); }
	
	private function UpdateUserParam(data:Object):void {
		_database.update(Tables.USER, DatabaseQuery.RowID(1), data, false);
	}
}
}
