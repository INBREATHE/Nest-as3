package app.model.data.popup
{
	public final class PausePopupData
	{
		private var _isPrevAvailable:Boolean;
		public function get isPrevAvailable():Boolean { return _isPrevAvailable; }
		
		private var _isNextAvailable:Boolean;
		public function get isNextAvailable():Boolean { return _isNextAvailable; }

		private var _isCompleted:Boolean;
		public function get isCompleted():Boolean { return _isCompleted; }

		private var _statistics:String;
		public function get statistics():String { return _statistics; }

		public function PausePopupData(	
				completed			: Boolean
			,	statistics			: String
			,	nextAvailable		: Boolean
			,	prevAvailable		: Boolean
		)
		{
			this._statistics = statistics;
			this._isCompleted = completed;
			this._isNextAvailable = nextAvailable;
			this._isPrevAvailable = prevAvailable;
		}
	}
}