package app.controller.commands.data
{
import app.model.proxy.DataProxy;
import app.model.proxy.LocalizerProxy;

import nest.patterns.command.SimpleCommand;

public final class GetGameCommand extends SimpleCommand
{
	[Inject] public var dataProxy		: DataProxy;
	[Inject] public var localizerProxy	: LocalizerProxy;

	override public function execute( callback:Object, levelName:String ):void
	{
//		const typeName : String = dataProxy.currentTypeName;
//
//		dataProxy.setCurrentLevelByName(levelName);
//		localizerProxy.setupLevelLocalize(
//			typeName,
//			dataProxy.currentBundleName,
//			dataProxy.currentLevelName
//		);
	}
}
}