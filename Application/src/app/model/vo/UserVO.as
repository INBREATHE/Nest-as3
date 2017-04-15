package app.model.vo 
{
import nest.utils.UIDUtil;

public class UserVO extends Object
{
	public var
		uuid				: String = UIDUtil.create()
	,	firstname			: String = "FirstName"
	,	lastname			: String = "LastName"

	,	gametree			: Object = {}
	,	score				: int = 0
	,	playtime			: int = 0
	,	lastplaytime		: int = 0

	,	gamesCompleted		: int = 0

	,	os					: String = ""
	,	lng					: String = ""
	,	version				: String = ""
	,	registered			: Boolean = false

	,	social				: Object = { }
	,	token				: String = ""
	,	mails				: Object = { }
	;
}
}