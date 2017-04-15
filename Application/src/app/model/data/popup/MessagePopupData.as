package app.model.data.popup
{
	import flash.geom.Point;

	public final class MessagePopupData
	{
		private var _position:Point;
		private var _text:String;
		public function MessagePopupData(text:String, position:Point)
		{
			this._text = text;
			this._position = position;
		}

		public function get position():Point
		{
			return _position;
		}

		public function get text():String
		{
			return _text;
		}


	}
}