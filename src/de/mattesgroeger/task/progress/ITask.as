package de.mattesgroeger.task.progress
{
	import org.spicefactory.lib.task.TaskGroup;
	import org.spicefactory.lib.task.enum.TaskState;

	import flash.events.IEventDispatcher;

	[Event(name="error", type="flash.events.ErrorEvent")]
	[Event(name="cancel", type="org.spicefactory.lib.task.events.TaskEvent")]
	[Event(name="resume", type="org.spicefactory.lib.task.events.TaskEvent")]
	[Event(name="suspend", type="org.spicefactory.lib.task.events.TaskEvent")]
	[Event(name="complete", type="org.spicefactory.lib.task.events.TaskEvent")]
	[Event(name="start", type="org.spicefactory.lib.task.events.TaskEvent")]
	public interface ITask extends IEventDispatcher
	{
		function cancel():Boolean;

		function get cancelable():Boolean;

		function get data():*;

		function set data(data:*):void;

		function get parent():TaskGroup;

		function get restartable():Boolean;

		function resume():Boolean;

		function skip():Boolean;

		function get skippable():Boolean;

		function start():Boolean;

		function get state():TaskState;

		function suspend():Boolean;

		function get suspendable():Boolean;

		function get timeout():uint;

		function toString():String;
	}
}
