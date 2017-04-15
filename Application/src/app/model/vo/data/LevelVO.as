package app.model.vo.data
{
	/**
	 * ...
	 * @author Vladimir Minkin (vk.com/dqvsra)
	 */
	public class LevelVO
	{
		/**
		 * STATIC PARAMS - FROM XML
		 */
		public var 		name			:String 		= "";
		public var 		lng				:String			= ""; // Language
		public var 		type			:String 		= "";
		public var 		lid				:int 			= int.MAX_VALUE;
		public var 		cost			:int 			= int.MAX_VALUE;
		public var 		score			:int 			= int.MAX_VALUE;
		public var 		specials		:String 		= "";
		public var 		rewards			:String 		= "";
		
		/**
		 * DYNAMIC PARAMS - FROM DB
		 */
		public var 		locked			:int 			= 0;
		public var 		completed		:int	 		= 0;
		public var 		progress		:int	 		= int.MAX_VALUE;
		public var 		playtime		:int 			= int.MAX_VALUE;
		public var 		steps			:int 			= int.MAX_VALUE;
		public var 		answers			:String 		= "";
		public var 		answered		:uint 			= 0;
		
		/**
		 * Здесь data хранит в себе массив уже отвеченных вопросов
		 * Это нужно для того, чтобы проверять получал ли пользователь
		 * бонусные очки за ответ на вопрос
		 */
		public var 		data			:String 		= "";
	}
}
