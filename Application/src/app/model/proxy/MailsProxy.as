package app.model.proxy
{
	import app.model.vo.MailVO;
	
	import consts.Tables;
	
	import nest.patterns.proxy.Proxy;
	import nest.services.database.DatabaseProxy;
	import nest.services.database.DatabaseQuery;
	
	public final class MailsProxy extends Proxy
	{
		public var unreadMessages:uint = 0;
		
		// Индикатор проверили ли мы наличие новых сообщений
		public var mailsChecked:Boolean = false;
		
		private var _database:DatabaseProxy;
		
		public function MailsProxy():void {
			super();
			reset();
		}
		
		override public function onRegister():void {
			_database = facade.retrieveProxy(DatabaseProxy) as DatabaseProxy;
		}
		
		//==================================================================================================
		// DATABASE INTERACTIONS
		//==================================================================================================
		public function storeMail(value:MailVO):void {
			unreadMessages++;
			mails.push(value);
			_database.store(Tables.MAILS, JSON.stringify(value));
		}
		
		public function loadMails():void {
			this.setData(_database.select(Tables.MAILS, DatabaseQuery.OrderBy("id"), MailVO, true) as Array);
		}
		//==================================================================================================
		
		public function readedMailByIndex( value:uint ):uint {
			const mails	: Array = this.data as Array;
			var counter	: uint = mails.length;
			var mail	: MailVO;
			while(counter--) {
				mail = mails[counter];
				if(mail.id == value) {
					SetMailReaded( mail );
					break;
				}
			}
			_database.update(Tables.MAILS, Tables.GetCriteriaFor_Mail(value), { isreaded : 1 });
			return unreadMessages;
		}
		
		public function removeMailByIndex( value:uint ):uint {
			const mails	: Array = this.data as Array;
			var counter	: uint = mails.length;
			var mail	: MailVO;
			while(counter--) {
				mail = mails[counter];
				if(mail.id == value) {
					mails.splice(counter, 1);
					if( mail.isreaded == false ) {
						unreadMessages--;
					}
					break;
				}
			}
			_database.remove(Tables.MAILS, Tables.GetCriteriaFor_Mail(value));
			return unreadMessages;
		}
		
		/**
		 * Сбрасывает текущий список писем
		 * Вызывается из: SetupLanguageMiscCommand
		 */
		public function reset( ):void {
			this.data = new Array();
			unreadMessages = 0;
		}
		
		/**
		 * Устанавливает, добавляет письма
		 * и проверяет их на прочтенность
		 * Вызывается из:
		 * 1. PrepareCompleteCommand
		 * 2. SetupLanguageMiscCommand
		 * 
		 * @param value - может быть массив с новыми письмами
		 */
		override public function setData(value:Object):void {
			if(value == null) return;
			if(this.data != null && value is Array) {
				(value as Array).forEach(CalculateUnreadMails);
				this.data = (this.data as Array).concat(value);
			}
			else {
				if(value != null) {
					(value as Array).forEach(CalculateUnreadMails);
					this.data = value;
				} else this.data = [];
			}
		}
		
		private function SetMailReaded( value:MailVO ):void {
			value.isreaded = 1;
			unreadMessages--;	
		}
		
		private function CalculateUnreadMails( mail:MailVO, index:uint, arr:Array ):void {
			if(mail.isreaded == 0) unreadMessages++;
		}
		
		private function get mails():Array { return data as Array; }
	}
}