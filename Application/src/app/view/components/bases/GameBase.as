package app.view.components.bases {
	
import starling.display.Sprite;

public class GameBase extends Sprite
{
	public static const TILE_SIZE:uint = 55;

	private var _actionID:uint = 0;

	protected var _actions:Vector.<String>;
	public var
		onTap			:String
	,	onTouchStart	:String
	,	onTouchEnd		:String
	;
	public function get action()		:String { return _actions[_actionID]; }

	protected const
		ROWS				:uint 		= 25
	,	COLUMNS				:uint 		= 25
	;

	public function GameBase()
	{
		super();
	}

	protected function dispatchToExecuteAction(actionID:uint, data:Object = null):void {
		_actionID = actionID;
//			this.dispatchEventWith(Events.INGAME_ACTION, false, data);
	}

	public function init(actions : Vector.<String>):void
	{
		_actions = actions;
	}
}
}
