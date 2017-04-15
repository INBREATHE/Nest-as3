/*
 NEST AS3 SingleCore
 Copyright (c) 2016 Vladimir Minkin <vladimir.minkin@gmail.com>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package nest.core
{
import flash.utils.Dictionary;

import nest.injector.Injector;
import nest.interfaces.IModel;
import nest.interfaces.IProxy;

public class Model implements IModel
{
	// Message Constants
	static protected var instance 	: IModel = new Model();
	protected const SINGLETON_MSG	: String = "Model Singleton already constructed!";

	protected const proxyMap : Dictionary = new Dictionary();

	//==================================================================================================
	public function Model() {
	//==================================================================================================
		if (instance != null) throw Error(SINGLETON_MSG);
		initializeModel();
	}

	protected function initializeModel() : void { }

	//==================================================================================================
	public static function getInstance() : IModel {
	//==================================================================================================
		return instance;
	}

	//==================================================================================================
	public function registerProxy( proxyClass:Class ) : void {
	//==================================================================================================
		const proxy:IProxy = new proxyClass();
		const proxyName:String = proxy.getProxyName();
		Injector.mapSource( proxyName, proxy );
		proxyMap[ proxyName ] = proxy;
		proxy.onRegister();
	}

	public function retrieveProxy( proxyName:String ) : IProxy { return proxyMap[ proxyName ]; }
	public function hasProxy( proxyName:String ) : Boolean { return proxyMap[ proxyName ] != null; }

	//==================================================================================================
	public function removeProxy( proxyName:String ) : IProxy {
	//==================================================================================================
		const proxy:IProxy = proxyMap [ proxyName ] as IProxy;
		if ( proxy ) {
			Injector.unmapSource( proxyName );
			delete proxyMap[ proxyName ];
			proxy.onRemove();
		}
		return proxy;
	}
}
}
