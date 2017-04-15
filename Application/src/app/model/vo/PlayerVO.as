package app.model.vo 
{
public class PlayerVO extends Object
{
	public var
		uuid				:String = ""
	,	firstname			:String = "Noname"
	,	lastname			:String = "Noname"
	,	nickname			:String = "Noname"
	,	status				:String = ""

	,	gametree			:Object = { }

	,	purchases			:Object = { }

	,	achivments			:String = ""
	,	specials			:String = ""
	,	rewards				:String = ""

	,	coins				:int = 0
	,	score				:int = 0
	,	level				:int = 0
	,	playtime			:int = 0
	,	lastplaytime		:int = 0

	,	synchronized		:Boolean = false
	;

}
}