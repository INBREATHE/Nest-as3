package app.view.mediators.screens 
{
import app.model.proxy.LocalizerProxy;
import app.view.components.screens.MainScreen;
import app.view.components.screens.MainScreen;

import consts.Screens;
import consts.commands.DataCommands;
import consts.commands.PopupCommands;
import consts.commands.ReportCommands;
import consts.notifications.DataNotifications;
import consts.notifications.TypesNotifications;

import nest.entities.screen.ScreenCommand;
import nest.entities.screen.ScreenMediator;
import nest.patterns.observer.NFunction;

import starling.core.Starling;
import starling.display.Canvas;

import starling.display.DisplayObject;
import starling.events.Event;

/**
 * ...
 * @author Vladimir Minkin
 */
public class MainScreenMediator extends ScreenMediator
{
	[Inject] public var localizerProxy	:LocalizerProxy;
	
	public function MainScreenMediator(viewComponent:Object) {
		super( 
			viewComponent, 
			DataNotifications.TAKE_MAIN,
			DataCommands.GET_MAIN
		);
	}
	
	override public function listNotificationsFunctions():Vector.<NFunction> {
		return new <NFunction>[
			new NFunction( ScreenCommand.LOCALIZE, 				LocalizeScreen )
		,	new NFunction( TypesNotifications.MAILS_CAME, 		"setUserMailsCount" )
		,	new NFunction( TypesNotifications.MAILS_CHANGED, 	"setUserMailsCount" )
		];
	}
	
	/**
	 * Этот метод вызывается когда мы переходим назад на этот экран
	*/
	override public function onReturn():void {
		super.onReturn();
	}
	
	//==================================================================================================
	private function LocalizeScreen(language:String):void {
	//==================================================================================================
		screen.clear();
		this.getDataForScreen();
	}

	//==================================================================================================
	private function Handler_Tap_Mails():void {
	//==================================================================================================
		trace("\nMailTapHandler");
		this.exec( PopupCommands.SHOW_MAILS );
	}
	
	//==================================================================================================
	private function Handler_Tap_Info():void {
	//==================================================================================================
		trace("\nInfoTouchHandler");
		this.exec( PopupCommands.SHOW_INFO, null, "types" );
		this.exec( ReportCommands.INFO_SHOWN, screen.name, "" );
	}
	
	//==================================================================================================
	private function Handler_Tap_Menu(event:String, index:int):void {
	//==================================================================================================
		trace("\nTypeTouchHandler", index);
		this.exec( ScreenCommand.CHANGE, index, Screens.LEVELS );
	}

	/**
	 * Эта функция обрабатывает данные собранные в прокси 
	 * на запрос _dataNotification из ScreenMediator
	 */
	//==================================================================================================
	override protected function TakeComponentData():void {
	//==================================================================================================
		trace("TakeComponentData");
		ContentReady();
	}
	
	/**
	 * Эта функция обрабатывает только Event.TRIGGERED из ScreenMediator
	 * Сделано для того чтобы было меньше событий
	 */
	//==================================================================================================
	override protected function ComponentTrigger(e:Event):void {
	//==================================================================================================
		trace("ComponentTrigger", e.target);
		switch (DisplayObject(e.target)) {
			case MainScreen(screen).btnMail: Handler_Tap_Mails(); break;
			case MainScreen(screen).btnInfo: Handler_Tap_Info(); break;
		}
	}
	
	/**
	 * Эта функция вызывается после вызова функции onLeave
	 * во время выполнения команды CHANGE_SCREEN
	 * Поскольку сам экран слушает события на добавление его на сцену,
	 * то здесь нельзя удалять все слушатели с экрана методом removeEventListeners
	 */
	//==================================================================================================
	override protected function RemoveComponentListeners():void {
	//==================================================================================================
	}
	
	/**
	 * Слушатели событий добавляются после того как контент готов,
	 * из метода ContentReady
	 */
	//==================================================================================================
	override protected function SetupComponentListeners():void {
	//==================================================================================================

	}
}
}
