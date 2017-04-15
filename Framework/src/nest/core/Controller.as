/*
 NEST AS3 SingleCore
 Copyright (c) 2016 Vladimir Minkin <vladimir.minkin@gmail.com>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package nest.core
{
import flash.errors.IllegalOperationError;
import flash.utils.Dictionary;

import nest.injector.Injector;
import nest.interfaces.ICommand;
import nest.interfaces.IController;
import nest.interfaces.INotification;
import nest.patterns.command.PromiseCommand;

public class Controller implements IController
{
	static protected var instance : IController = new Controller();
	static private const SINGLETON_MSG : String = "Controller Singleton already constructed!";

	private const commandMap 			: Dictionary = new Dictionary();
	private const commandReplyCountMap 	: Dictionary = new Dictionary();

	//==================================================================================================
	public function Controller() {
	//==================================================================================================
		if (instance != null) throw Error(SINGLETON_MSG);
		initializeController();
	}

	protected function initializeController() : void { }

	//==================================================================================================
	public static function getInstance() : IController {
	//==================================================================================================
		return instance;
	}

	//==================================================================================================
	public function executeCommand( note : INotification ) : * {
	//==================================================================================================
		const commandName 	: String 	= note.getName();
		const commandBody 	: Object 	= note.getBody();
		const commandType 	: String 	= note.getType();

		var commandInstance : ICommand;
		if(commandMap[ commandName ] is Class) {
			const commandClassRef : Class = commandMap[commandName] as Class;
			commandInstance = new commandClassRef();
			if(Injector.hasTarget( commandClassRef ))
				Injector.injectTo( commandClassRef, commandInstance );
		} else commandInstance = commandMap[ commandName ];

		if(commandInstance)	{
			var replyCount:int = commandReplyCountMap[ commandName ];
			if(replyCount) {
				if(--replyCount == 0) {
					delete commandReplyCountMap[ commandName ];
					removeCommand( commandName );
				} else {
					commandReplyCountMap[ commandName ] = replyCount;
				}
			}
			commandInstance.execute( commandBody, commandType );
			if(commandInstance is PromiseCommand) {
				return PromiseCommand(commandInstance).promise;
			}
		}
		else throw IllegalOperationError("Command does not exist: " + commandName);
	}

	//==================================================================================================
	public function registerCommand( commandClassName : String, commandClassRef : Class ) : void {
	//==================================================================================================
		Injector.mapTarget( commandClassRef );
		commandMap[ commandClassName ] = commandClassRef;
	}

	//==================================================================================================
	public function registerPoolCommand( commandClassName : String, commandClassRef : Class ):void {
	//==================================================================================================
		const commandInstance:ICommand = new commandClassRef();
		Injector.mapTarget( commandClassRef );
		if(Injector.hasTarget(commandClassRef))
            Injector.injectTo( commandClassRef, commandInstance );
		commandMap[ commandClassName ] = commandInstance;
	}

	//==================================================================================================
	public function registerCountCommand( commandClassName : String, commandClassRef : Class, replyCount:int ) : void {
	//==================================================================================================
		if(replyCount < 0) registerPoolCommand( commandClassName, commandClassRef );
		else {
			if(replyCount > 0) commandReplyCountMap[ commandClassName ] = replyCount;
			registerCommand( commandClassName, commandClassRef );
		}
	}

	//==================================================================================================
	public function registerPromiseCommand( notificationName : String, commandClassRef : Class ):void {
	//==================================================================================================

	}

	//==================================================================================================
	public function hasCommand( commandName : String ) : Boolean {
	//==================================================================================================
		return commandMap[ commandName ] != null;
	}

	//==================================================================================================
	public function removeCommand( commandName : String ) : Boolean {
	//==================================================================================================
		if ( hasCommand( commandName ) ) {
			Injector.unmapTarget( commandMap[ commandName ] );
			delete commandMap[ commandName ];
			return true;
		}
		return false;
	}
}
}