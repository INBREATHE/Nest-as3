package app.model.data.event
{
	public final class MailMessageData
	{
		private var _id:uint;

		public function get id():uint
		{
			return _id;
		}

		private var _remove:Boolean;

		public function get remove():Boolean
		{
			return _remove;
		}

		public function MailMessageData(id:uint, remove:Boolean)
		{
			this._remove = remove;
			this._id = id;
		}
	}
}