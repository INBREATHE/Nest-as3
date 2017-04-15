/*
 NEST AS3 SingleCore
 Copyright (c) 2016 Vladimir Minkin <vladimir.minkin@gmail.com>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package nest.core
{
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;

import nest.injector.Injector;
import nest.interfaces.IMediator;
import nest.interfaces.INotification;
import nest.interfaces.IObserver;
import nest.interfaces.IView;
import nest.patterns.observer.NFunction;
import nest.patterns.observer.Observer;

public class View implements IView
{
	// Message Constants
	static protected var instance	: IView = new View();
	protected const SINGLETON_MSG	: String = "View Singleton already constructed!";

	protected var mediatorMap 		: Dictionary = new Dictionary();
	protected var observerMap		: Dictionary = new Dictionary();

	private var _observers:Vector.<IObserver>;

	public function View( ) {
		if (instance != null) throw Error(SINGLETON_MSG);
		initializeView();
	}

	public static function getInstance() : IView {
		return instance;
	}

	//==================================================================================================
	public function registerObserver ( notificationName:String, observer:IObserver ) : void {
	//==================================================================================================
		_observers = observerMap[ notificationName ];
		if( _observers ) {
			_observers.push( observer );
		} else {
			observerMap[ notificationName ] = new <IObserver>[ observer ];
		}
	}

	//==================================================================================================
	public function notifyObservers( notification:INotification ) : void {
	//==================================================================================================
		const notificationName:String = notification.getName();
		_observers = observerMap[ notificationName ];
		if( _observers != null ) {
			_observers.forEach(function(observer:IObserver, index:uint, vector:Vector.<IObserver>) : void {
				if(observer) observer.notifyObserver( notification );
			});
		}
	}

	//==================================================================================================
	public function registerMediator( mediator:IMediator ) : void {
	//==================================================================================================
		const mediatorName:String = mediator.getMediatorName();
		if ( mediatorMap[ mediatorName ] != null ) return;
		mediatorMap[ mediatorName ] = mediator;
		InjectToMediator( mediator );
		const interests:Vector.<String> = mediator.listNotificationInterests();
		var listCounter:uint = interests.length;
		if ( listCounter > 0 ) {
			const observer:Observer = new Observer( mediator.handleNotification, mediator );
			while(listCounter--) registerObserver( interests[listCounter], observer );
		}
		mediator.onRegister();
	}

	//==================================================================================================
	public function registerMediatorAdvance( mediator:IMediator ) : void {
	//==================================================================================================
		const mediatorName:String = mediator.getMediatorName();
		if ( mediatorMap[ mediatorName ] != null ) return;

		mediatorMap[ mediatorName ] = mediator;
		InjectToMediator( mediator );

		const interestsNotes:Vector.<String> 		= mediator.listNotificationInterests();
		const interestsNFunc:Vector.<NFunction> 	= mediator.listNotificationsFunctions();

		var listCounter:uint = interestsNFunc.length;

		var notifyMethod	: Function
		,	notifyContext	: Object
		,	notifyName		: String
		;

		var observer:Observer;
		var nFunction:NFunction;
		if ( listCounter > 0 ) {
			while(listCounter--) {
				nFunction = interestsNFunc[listCounter];
				notifyName = nFunction.name;
				switch(typeof nFunction.func) {
					case NFunction.TYPE_STRING:
						notifyContext = Object(mediator.getViewComponent());
						notifyMethod = notifyContext[String(nFunction.func)] as Function;
						break;
					case NFunction.TYPE_FUNCTION:
						notifyContext = mediator;
						notifyMethod = nFunction.func as Function;
						break;
				}
				observer = new Observer( notifyMethod, notifyContext, true );
				registerObserver( notifyName,  observer );
			}
		}

		//REGISTER LIST NOTIFICATIONS
		listCounter = interestsNotes.length;
		if(listCounter > 0) {
			observer = new Observer( mediator.handleNotification, mediator );
			while(listCounter--){
				notifyName = interestsNotes[listCounter];
				registerObserver( notifyName,  observer );
			}
		}

		mediator.onRegister();
	}

	//==================================================================================================
	public function removeMediator( mediatorName:String ) : IMediator {
	//==================================================================================================
		const mediator:IMediator = mediatorMap[ mediatorName ] as IMediator;
		if ( mediator ) {
			const interests:Vector.<String> = mediator.listNotificationInterests();
			var listCounter:uint = interests.length;
			var notificationName:String = "";
			while(listCounter--) {
				notificationName = interests[listCounter];
				RemoveObserver(notificationName , mediator );
			}
			delete mediatorMap[ mediatorName ];
			Injector.unmapTarget( getDefinitionByName( mediator.getMediatorName() ) as Class );
			mediator.onRemove();
		}
		return mediator;
	}

	//==================================================================================================
	protected function initializeView(  ) : void { }
	//==================================================================================================

	//==================================================================================================
	public function retrieveMediator( mediatorName:String ) : IMediator { return mediatorMap[ mediatorName ]; }
	public function hasMediator( mediatorName:String ) : Boolean { return mediatorMap[ mediatorName ] != null; }
	//==================================================================================================

	//==================================================================================================
	private function RemoveObserver( notificationName:String, notifyContext:Object ):void {
	//==================================================================================================
		_observers = observerMap[ notificationName ] as Vector.<IObserver>;
		var count:uint = _observers.length;
		var observer:IObserver;
		while(count--) {
			observer = IObserver(_observers[count]);
			if ( observer.compareNotifyContext( notifyContext ) == true ) {
				_observers.splice(count, 1);
				break;
			}
		}

		if ( _observers.length == 0 ) {
			delete observerMap[ notificationName ];
		}
	}

	//==================================================================================================
	private function InjectToMediator( mediator:IMediator ):void {
	//==================================================================================================
		const mediatorClass:Class = getDefinitionByName( mediator.getMediatorName() ) as Class;
		if(!Injector.hasTarget( mediatorClass ))
			Injector.mapTarget( mediatorClass );

        if(Injector.hasTarget( mediatorClass ))
		    Injector.injectTo( mediatorClass , mediator );
	}
}
}