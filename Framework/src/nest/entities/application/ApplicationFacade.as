/*
 NEST AS3 SingleCore
 Copyright (c) 2016 Vladimir Minkin <vladimir.minkin@gmail.com>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package nest.entities.application 
{
import nest.entities.screen.ScreenCommand;
import nest.entities.screen.ScreensProxy;
import nest.entities.screen.commands.ChangeScreenCommand;
import nest.entities.screen.commands.RegisterScreenCommand;
import nest.entities.screen.commands.RemoveScreenCommand;
import nest.interfaces.IFacade;
import nest.patterns.facade.Facade;
import nest.patterns.observer.Notification;
import nest.services.cache.commands.BatchReportsCacheCommand;
import nest.services.cache.commands.BatchRequestsCacheCommand;
import nest.services.cache.commands.CacheReportCommand;
import nest.services.cache.commands.CacheRequestCommand;
import nest.services.cache.commands.ClearReportCacheCommand;
import nest.services.cache.commands.ClearRequestCacheCommand;
import nest.services.database.DatabaseProxy;
import nest.services.network.NetworkProxy;
import nest.services.reports.ReportProxy;
import nest.services.reports.commands.SendReportCommand;
import nest.services.server.ServerProxy;
import nest.services.server.commands.ServerRequestCommand;
import nest.services.server.commands.ServerResponceCommand;

import starling.core.Starling;

public class ApplicationFacade extends Facade implements IFacade
{
	public static const
		STARTUP		: String = "nest_command_application_startup"
	,	READY		: String = "nest_command_application_ready"
	;

	public function ApplicationFacade():void { super( ); }
	public static function getInstance() : ApplicationFacade {
		if ( instance == null ) instance = new ApplicationFacade();
		return instance as ApplicationFacade;
	}

	//==================================================================================================
	override protected function initializeView():void {
	//==================================================================================================
		super.initializeView();
		registerMediatorAdvance(new ApplicationMediator(Starling.current.root));
	}

	//==================================================================================================
	override protected function initializeModel():void {
	//==================================================================================================
		super.initializeModel();

		registerProxy( ReportProxy 		);
		registerProxy( ServerProxy 		);
		registerProxy( NetworkProxy 	);
		registerProxy( ScreensProxy 	);
		registerProxy( DatabaseProxy 	);
	}

	//==================================================================================================
	override protected function initializeController():void {
	//==================================================================================================
		super.initializeController();

		registerPoolCommand( ScreenCommand.REGISTER, 			RegisterScreenCommand 	);
		registerPoolCommand( ScreenCommand.CHANGE, 				ChangeScreenCommand 	);
		registerPoolCommand( ScreenCommand.REMOVE, 				RemoveScreenCommand 	);

		registerPoolCommand( ApplicationCommand.SERVER_REQUEST, 		ServerRequestCommand 		);
		registerPoolCommand( ApplicationCommand.SERVER_RESPONCE, 		ServerResponceCommand 		);

		registerPoolCommand( ApplicationCommand.SINGLE_REPORT,			SendReportCommand			);

		registerPoolCommand( ApplicationCommand.CACHE_BATCH_REPORT,		BatchReportsCacheCommand 	);
		registerPoolCommand( ApplicationCommand.CACHE_BATCH_REQUESTS,	BatchRequestsCacheCommand 	);
		registerPoolCommand( ApplicationCommand.CACHE_STORE_REPORT,		CacheReportCommand 			);
		registerPoolCommand( ApplicationCommand.CACHE_STORE_REQUEST,	CacheRequestCommand		 	);
		registerPoolCommand( ApplicationCommand.CACHE_CLEAR_REPORT, 	ClearReportCacheCommand 	);
		registerPoolCommand( ApplicationCommand.CACHE_CLEAR_REQUEST, 	ClearRequestCacheCommand 	);
	}

	//==================================================================================================
	public function startup( root:Object ):void {
	//==================================================================================================
		this.executeCommand( new Notification( STARTUP, root ));
	}
}
}
