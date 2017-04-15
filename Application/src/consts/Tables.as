package consts
{
	public final class Tables
	{
		public static const		
			USER		: String 	= "user"
		,	LEVELS		: String 	= "levels"
		,	MAILS		: String 	= "mails"

		,	APP			: String 	= "app "
		;
			
		private static const
			CRITERIA_LEVEL			: Array 	= [ "name='", "1", "'" ]
		,	CRITERIA_MAIL			: Array 	= [ "id='", "1", "'" ]
		;
			
		public static function GetCriteriaFor_Level(name:String):String {
			CRITERIA_LEVEL[1] = name;
			return CRITERIA_LEVEL.join("");
		}	

		public static function GetCriteriaFor_Mail(id:uint):String {
			CRITERIA_MAIL[1] = id.toString();
			return CRITERIA_MAIL.join("");
		}
	}
}