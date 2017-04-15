package app.model.data.popup
{
	public final class ConfirmPopupData
	{
		private var _action:String;
		
		private var _title:String;
		private var _message:String;
		
		private var _callback:Function;
		private var _single:Boolean;

		public function set title(value:String):void { _title = value; }
		public function get title():String { return _title; }
		
		public function set message(value:String):void { _message = value; }
		public function get message():String { return _message; }
		
		public function get action()	:String 	{ return _action; 	}
		public function get callback()	:Function 	{ return _callback;	}
		public function get single()	:Boolean 	{ return _single;	}

		public function ConfirmPopupData(action:String, callback:Function, single:Boolean = false)
		{
			_callback = callback;
			_action = action;
			_single = single;
		}
	}
}