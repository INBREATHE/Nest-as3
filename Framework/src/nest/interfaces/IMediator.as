/*
 NEST AS3 SingleCore
 Copyright (c) 2016 Vladimir Minkin <vladimir.minkin@gmail.com>
 Your reuse is governed by the Creative Commons Attribution 3.0 License
*/
package nest.interfaces
{
import nest.patterns.observer.NFunction;

public interface IMediator extends INotifier
{
	function getMediatorName():String;
	function getViewComponent():Object;
	function setViewComponent(value:Object):void;
	function listNotificationInterests():Vector.<String>;
	function listNotificationsFunctions():Vector.<NFunction>;
	function handleNotification(note:INotification):void;
	function onRegister():void;
	function onRemove():void;
}
}