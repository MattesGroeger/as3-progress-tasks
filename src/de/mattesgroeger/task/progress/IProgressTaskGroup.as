package de.mattesgroeger.task.progress
{
	import org.spicefactory.lib.task.Task;

	[Event(name="progress", type="de.mattesgroeger.task.progress.events.ProgressTaskEvent")]
	public interface IProgressTaskGroup extends ITaskGroup
	{
		function addTaskWeighted(task:Task, weight:uint):Boolean;
		
		function progressChild(task:Task, progress:Number, childLabel:String):void;
	}
}