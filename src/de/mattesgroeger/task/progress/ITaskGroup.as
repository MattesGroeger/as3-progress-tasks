package de.mattesgroeger.task.progress
{
	import org.spicefactory.lib.task.Task;

	public interface ITaskGroup extends ITask
	{
		function addTask(task:Task):Boolean;

		function removeTask(task:Task):Boolean;
		
		function get autoStart():Boolean;

		function set autoStart(autoStart:Boolean):void;

		function getTask(index:uint):Task;
		
		function get ignoreChildErrors():Boolean;

		function set ignoreChildErrors(ignore:Boolean):void;
		
		function removeAllTasks():void;

		function get size():uint;

		function set timeout(value:uint):void;
	}
}
