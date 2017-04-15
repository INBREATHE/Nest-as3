/**
 * ...
 * @author Vladimir Minkin
 */

package app.view.mediators.screens 
{
import flash.geom.Point;

import app.model.proxy.LocalizerProxy;
import app.model.proxy.data.LevelsProxy;
import app.model.vo.data.LevelVO;
import app.view.components.screens.LevelsScreen;

import consts.Messages;
import consts.Screens;
import consts.commands.DataCommands;
import consts.commands.ReportCommands;
import consts.commands.PopupCommands;
import consts.commands.PurchaseCommands;
import consts.events.Events;
import consts.notifications.DataNotifications;
import consts.notifications.LevelsNotifications;

import nest.entities.screen.Screen;

import nest.entities.screen.ScreenCommand;
import nest.entities.screen.ScreenMediator;
import nest.patterns.observer.NFunction;

import starling.display.DisplayObject;
import starling.events.Event;

public class LevelsScreenMediator extends ScreenMediator
{
	[Inject] public var levelsProxy:LevelsProxy;
	[Inject] public var localizerProxy:LocalizerProxy;

	static private const
		LEVELS_METHOD__COMPLETE		:String = "levelComplete"
	,	LEVELS_METHOD__UNLOCK		:String = "levelUnlock"
	,	LEVELS_METHOD__RESET		:String = "levelReset"
	;

	public function LevelsScreenMediator( viewComponent:Object ) {
		super( viewComponent, DataNotifications.TAKE_LEVELS, DataCommands.GET_LEVELS, true );
	}

	//==================================================================================================
	override public function listNotificationsFunctions():Vector.<NFunction> {
	//==================================================================================================
		return new <NFunction>[
			new NFunction( LevelsNotifications.UNLOCK, 		LEVELS_METHOD__UNLOCK	)
		,	new NFunction( LevelsNotifications.COMPLETE, 	LEVELS_METHOD__COMPLETE	)
		,	new NFunction( LevelsNotifications.RESET, 		LEVELS_METHOD__RESET	)
		];
	}

	//==================================================================================================
	override protected function TakeComponentData():void {
	//==================================================================================================
		const elements		:Array = levelsProxy.getData() as Array;
		var levelVO			:LevelVO = elements[0];
		const typeName		:String = levelVO.type;
		for (var i:uint = 0; levelVO != null; levelVO = elements[i]) {
			LevelsScreen(screen).addElementToScrollItem(i++, levelVO.locked, levelVO.completed);
		}
		LevelsScreen(screen).setupScrollContainer();
		LevelsScreen(screen).setTypeTitle(localizerProxy.getTypeTitleByName(typeName));
		screen.isClearWhenRemove = false;
		ContentReady();
	}

	//==================================================================================================
	override protected function Handle_Android_BackButton():void {
	//==================================================================================================
		Handle_Tap_Back();
	}

	//==================================================================================================
	private function Handle_Tap_Back():void {
	//==================================================================================================
		trace("\nBackTouchHandler");
		screen.isClearWhenRemove = true;
		this.exec( ScreenCommand.CHANGE, null, Screen.PREVIOUS );
	}

	//==================================================================================================
	protected function Handle_Show_LevelBuyMessage(target:DisplayObject):void {
	//==================================================================================================
		this.exec( PopupCommands.SHOW_MESSAGE, new Point(target.x, target.y), Messages.BUYLEVEL);
	}

	//==================================================================================================
	private function Handle_Tap_Level(event:Event, item:Object):void {
	//==================================================================================================
		// item = { index:touchItemIndex, locked:locked, position:position }
		trace("LevelsScreenMediator - LevelTapHandler", index);
		const index:uint = item.index;
		const locked:Boolean = item.locked;
		if(locked)
				this.exec( PopupCommands.SHOW_MESSAGE, item.position, Messages.BUYLEVEL);
		else 	this.exec( ScreenCommand.CHANGE, index, Screens.GAME);
	}

	//==================================================================================================
	private function Handle_Hold_Level(event:Event, index:uint):void {
	//==================================================================================================
		trace("LevelsScreenMediator - Handle_Hold_Level", index);
		this.exec( PurchaseCommands.LEVEL, index );
	}

	//==================================================================================================
	private function Handle_Tap_Info():void {
	//==================================================================================================
		/** ADNROID - При открытии popup с информацией отключаем восприятие назад  */
		this.isBackPossible = false;
		this.exec( PopupCommands.SHOW_INFO );
		this.exec( ReportCommands.INFO_SHOWN, screen.name );
	}

	//==================================================================================================
	override protected function ComponentTrigger(e:Event):void {
	//==================================================================================================
		switch (DisplayObject(e.target)) {
			case LevelsScreen(screen).btnBack: Handle_Tap_Back(); break;
			case LevelsScreen(screen).btnInfo: Handle_Tap_Info(); break;
		}
	}

	//==================================================================================================
	override protected function RemoveComponentListeners():void {
	//==================================================================================================
//			trace("LevelsScreenMediator - RemoveListeners:", screen);
		screen.removeEventListener(Events.TAP_HAPPEND_LEVEL, Handle_Tap_Level);
		screen.removeEventListener(Events.HOLD_START, Handle_Hold_Level);
	}

	//==================================================================================================
	override protected function SetupComponentListeners():void {
	//==================================================================================================
//			trace("LevelsScreenMediator - SetupListeners");
		screen.addEventListener(Events.TAP_HAPPEND_LEVEL, Handle_Tap_Level);
		screen.addEventListener(Events.HOLD_START, Handle_Hold_Level);
	}
}
}
