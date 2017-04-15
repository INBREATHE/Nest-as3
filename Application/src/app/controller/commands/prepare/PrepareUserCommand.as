package app.controller.commands.prepare
{
import app.controller.commands.server.RegisterUserServerCommand;
import app.model.proxy.UserProxy;
import app.model.vo.UserVO;

import consts.commands.ServerCommands;

import flash.system.Capabilities;

import nest.entities.application.Application;
import nest.entities.application.ApplicationCommand;

import nest.patterns.command.SimpleCommand;
import nest.services.network.NetworkProxy;

public class PrepareUserCommand extends SimpleCommand
{
    [Inject] public var networkProxy	: NetworkProxy;
    [Inject] public var userProxy		: UserProxy;

    override public function execute( body:Object, type:String ):void
    {
        // Get user and initialize them into application
        var user:UserVO = userProxy.getUser();
        if (user == null) {
            user 			= new UserVO();
            user.os 		= Capabilities.version;
            user.version 	= Application.version;
            user.lng 		= this.getCurrentLanguage();
            userProxy.setUser(user);
        }

        trace("> App -> User Synchronized: ", user.registered, JSON.stringify(user));

        if( user.registered == false ) {
            facade.registerCountCommand( ServerCommands.REGISTER_USER, 	RegisterUserServerCommand, 1 );
            this.exec( ServerCommands.REGISTER_USER, user );
        } else {
            if(networkProxy.isNetworkAvailable) {
                this.exec( ServerCommands.GET_USER_MAILS );
                this.exec( ApplicationCommand.CACHE_BATCH_REQUESTS );
                this.exec( ApplicationCommand.CACHE_BATCH_REPORT );
            }
        }
    }
}
}
