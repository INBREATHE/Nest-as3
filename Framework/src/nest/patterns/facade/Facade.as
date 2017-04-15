/*
 NEST AS3 SingleCore
 Copyright (c) 2016 Vladimir Minkin <vladimir.minkin@gmail.com>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package nest.patterns.facade
{
import flash.utils.getQualifiedClassName;

import nest.core.Controller;
import nest.core.Model;

import nest.core.View;

import nest.interfaces.IController;
import nest.interfaces.IFacade;
import nest.interfaces.IMediator;
import nest.interfaces.IModel;
import nest.interfaces.INotification;
import nest.interfaces.IProxy;
import nest.interfaces.IView;

public class Facade implements IFacade
{
	static protected var instance : IFacade;
	protected const SINGLETON_MSG	: String = "Facade Singleton already constructed!";

	protected var
		controller 	: IController 	= Controller.getInstance()
	,	model		: IModel 		= Model.getInstance()
	,	view		: IView 		= View.getInstance()
	;

	public static function getInstance():IFacade { return instance; }

	public function Facade() {
		if (instance != null) throw Error(SINGLETON_MSG);
        instance = this;
		initializeFacade();
	}

	protected function initializeFacade():void {
		initializeModel();
		initializeController();
		initializeView();
	}

	private var _language:String;

	// PROPERTIES
	//========================================================================================================================================
	public function get currentLanguage():String { return _language; }
	public function set currentLanguage(value:String):void { _language = value; }
	//========================================================================================================================================

	// INITIALIZE
	//========================================================================================================================================
	protected function initializeController()	:void { if ( controller != null ) return; 	}
	protected function initializeModel()		:void { if ( model != null ) return; 		}
	protected function initializeView()			:void { if ( view != null ) return;			}
	//========================================================================================================================================

	// REGISTER
	//========================================================================================================================================
	public function registerProxy 			( proxyClass:Class )			: void 		{ model.registerProxy ( proxyClass ); 			}
	public function registerProcess			( process:Class )				: void 		{ }
	public function registerCommand			( name:String, clss:Class )		: void 		{ controller.registerCommand( name, clss );  	}
	public function registerPoolCommand		( name:String, clss:Class )		: void 		{ controller.registerPoolCommand( name, clss );  	}
	public function registerPromiseCommand	( name:String, clss:Class )		: void 		{ controller.registerPromiseCommand( name, clss );  	}

	public function registerCountCommand	( name:String, clss:Class, count:int ) : void { controller.registerCountCommand( name, clss, count );  	}

	public function registerMediator		( mediator:IMediator )			: void 		{ view.registerMediator( mediator ); 			}
	public function registerMediatorAdvance	( mediator:IMediator )			: void 		{ view.registerMediatorAdvance( mediator ); 	}
	//========================================================================================================================================

	// HAS
	//========================================================================================================================================
	public function hasProxy			( proxyName:String ) 			: Boolean 	{ return model.hasProxy( proxyName ); }
	public function hasProcess			( process:Class ) 				: Boolean 	{ return false; }
	public function hasCommand			( commandName:String ) 			: Boolean 	{ return controller.hasCommand( commandName ); }
	public function hasMediator			( mediatorName:String ) 		: Boolean 	{ return view.hasMediator( mediatorName ); }
	//========================================================================================================================================

	// RETRIEVE
	//========================================================================================================================================
	public function retrieveProxy 		( proxyName:Class )				: IProxy 	{ return model.retrieveProxy ( getQualifiedClassName(proxyName) ); }
	public function retrieveMediator	( mediatorName:String )			: IMediator { return view.retrieveMediator( mediatorName ) as IMediator; }
	//========================================================================================================================================

	// REMOVE
	//========================================================================================================================================
	public function removeProxy 		( proxyName:String )			: IProxy 	{ return model.removeProxy ( proxyName ); }
	public function removeProcess 		( processName:Class )			: void	 	{ }
	public function removeCommand		( commandName:String )			: void 		{ controller.removeCommand( commandName ); }
	public function removeMediator		( mediatorName:String ) 		: IMediator { return view.removeMediator( mediatorName ); }
	//========================================================================================================================================

	// IFacade
	//========================================================================================================================================
	public function sendNotification 	( notification:INotification )	: void 		{ view.notifyObservers( notification ); }
	public function executeCommand	 	( notification:INotification )	: * 		{ return controller.executeCommand( notification ); }
	public function runProcess 			( notification:INotification )	: void 		{  }
	//========================================================================================================================================
}
}
