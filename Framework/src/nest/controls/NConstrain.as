/*
 NEST AS3 SingleCore
 Copyright (c) 2016 Vladimir Minkin <vladimir.minkin@gmail.com>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package nest.controls
{
	import flash.display.DisplayObject;

	public class NConstrain extends DisplayObject
	{
		static public var LEFT:Object = "left";
		public static var RIGHT:Object = "right";
		public static var CENTER:Object = "center";
		public static var NONE:Object = "none";
		public static var TOP:Object = "top";
		public static var BOTTOM:Object = "bottom";
		
		public var constrainX:Object;
		public var constrainY:Object;
		
		public function NConstrain()
		{
		}
	}
}