package app.controller.commands.data {
import consts.notifications.DataNotifications;

import nest.patterns.command.SimpleCommand;

public class GetMainCommand extends SimpleCommand {
    override public function execute( body:Object, type:String ):void
    {
        this.send( DataNotifications.TAKE_MAIN );
    }
}
}
