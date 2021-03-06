/*
 NEST AS3 SingleCore
 Copyright (c) 2016 Vladimir Minkin <vladimir.minkin@gmail.com>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package nest.entities.elements
{
import nest.entities.elements.transitions.Transition;
import nest.entities.screen.Screen;

import starling.display.DisplayObjectContainer;

public class Navigator
{
	private var
		_container	: DisplayObjectContainer
	;

	private var _transition:Transition;

	public function Navigator(container:DisplayObjectContainer, transition:Transition) {
		_container = container;
		_transition = transition;

		_transition.onHideComplete 	= RemoveScreen;
		_transition.onShowStart 	= AddScreenToApp;
		_transition.onShowComplete 	= ScreenChangeComplete;
	}

	//==================================================================================================
	public function showScreen( screen:Screen, isReturn:Boolean ):void {
	//==================================================================================================
		if(_transition.isShowPossible) {
			_container.addChild(screen);
			screen.show();
		} else {
			_transition.show(screen, isReturn);
		}
	}

	//==================================================================================================
	public function hideScreen( screen:Screen, isReturn:Boolean ):void {
	//==================================================================================================
		// From base class Transistion.as
		// Default:  _transition.isHidePossible == false
		if(_transition.isHidePossible) {
			_transition.hide(screen, isReturn);
		} else {
			screen.hide(function():void{
				_transition.hide(screen, isReturn);
			});
		}
	}

	//==================================================================================================
	private function RemoveScreen(screen:Screen):void {
	//==================================================================================================
		screen.removeFromParent();
	}

	//==================================================================================================
	private function ScreenChangeComplete(screen:Screen):void {
	//==================================================================================================
		screen.show();
	}

	//==================================================================================================
	private function AddScreenToApp(screen:Screen):void {
	//==================================================================================================
		_container.addChild(screen);
	}
}
}