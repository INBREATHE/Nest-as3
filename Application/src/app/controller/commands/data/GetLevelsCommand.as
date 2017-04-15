/**
 * ...
 * @author Vladimir Minkin
 */

package app.controller.commands.data 
{
	import app.model.proxy.DataProxy;
	import app.model.proxy.UserProxy;
	import app.model.proxy.data.LevelsProxy;
	
	import consts.commands.ReportCommands;
	import consts.modules.ToDataProcessorNotifications;
	import consts.notifications.DataNotifications;
	
	import nest.patterns.command.SimpleCommand;
	
	public class GetLevelsCommand extends SimpleCommand
	{
		[Inject] public var levelsProxy		: LevelsProxy;

		[Inject] public var dataProxy		: DataProxy;
		[Inject] public var userProxy		: UserProxy;
		
		override public function execute( body:Object, type:String ):void 
		{
			const	index		: uint 	 	= int(body);
//			const	typeName	: String 	= bundlesProxy.currentTypeName;
//			const	bundleName	: String 	= bundlesProxy.getBundleNameByIndex(index);
			
//			levelsProxy.currentBundleName = bundleName;
//			levelsProxy.currentTypeName = typeName;
//			bundlesProxy.setCurrentBundleByIndex(index);
			
//			this.send(ToDataProcessorNotifications.GET_LEVELS_DATA, ProcessLevel, bundleName);
		}
		
		private function ProcessLevel(data:Array):void 
		{
			levelsProxy.setData(data);
			
			this.send( DataNotifications.TAKE_LEVELS );	
//			this.exec( ReportCommands.BUNDLE_OPENED, levelsProxy.currentBundleName, bundlesProxy.currentTypeName); // Statistics
		}
	}		
}
