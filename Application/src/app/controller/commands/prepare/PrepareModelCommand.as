package app.controller.commands.prepare
{
import app.model.proxy.DataProxy;
import app.model.vo.ApplicationVO;
import flash.utils.Dictionary;
import app.model.proxy.LocalizerProxy;
import app.model.proxy.MailsProxy;
import app.model.proxy.SettingsProxy;
import app.model.proxy.SocialProxy;
import app.model.proxy.StatsProxy;
import app.model.proxy.UserProxy;
import app.model.proxy.data.GameProxy;
import app.model.proxy.data.LevelsProxy;
import app.model.vo.MailVO;
import app.model.vo.UserVO;
import app.model.vo.data.LevelVO;

import consts.Tables;

import nest.patterns.command.AsyncCommand;
import nest.services.cache.CacheProxy;
import nest.services.database.DatabaseProxy;

public class PrepareModelCommand extends AsyncCommand
{
	// This proxy is initial created at core level
	[Inject] public var databaseProxy : DatabaseProxy;

	override public function execute( body:Object, type:String ):void
	{
		if(!databaseProxy.dbExist)
		{
			const tables:Dictionary = new Dictionary(true);
			tables[ Tables.APP		] = ApplicationVO;
			tables[ Tables.USER		] = UserVO;
			tables[ Tables.MAILS	] = MailVO;
			tables[ Tables.LEVELS	] = LevelVO;
			databaseProxy.create(tables);
		}

		facade.registerProxy( DataProxy );
		facade.registerProxy( UserProxy );
		facade.registerProxy( MailsProxy );
		facade.registerProxy( CacheProxy );
		facade.registerProxy( StatsProxy );
		facade.registerProxy( SocialProxy );
		facade.registerProxy( SettingsProxy );
		facade.registerProxy( LocalizerProxy );

		facade.registerProxy( LevelsProxy 	);
		facade.registerProxy( GameProxy 	);

		commandComplete();
	}
}
}
