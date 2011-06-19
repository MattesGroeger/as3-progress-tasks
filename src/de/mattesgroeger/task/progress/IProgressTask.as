package de.mattesgroeger.task.progress
{
	[Event(name="progress", type="de.mattesgroeger.task.progress.events.ProgressTaskEvent")]
	public interface IProgressTask extends ITask
	{
		function get label():String

		function set label(label:String):void
	}
}
