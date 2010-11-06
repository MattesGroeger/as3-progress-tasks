/*
 * Copyright (c) 2010 Mattes Groeger
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package de.mattesgroeger.task.progress
{
	import de.mattesgroeger.task.progress.events.ProgressTaskEvent;

	import org.spicefactory.lib.task.SequentialTaskGroup;
	import org.spicefactory.lib.task.Task;
	import org.spicefactory.lib.task.enum.TaskState;

	import flash.utils.Dictionary;
	
	[Event(name="progress", type="de.mattesgroeger.task.progress.events.ProgressTaskEvent")]
	public class ProgressTaskGroup extends SequentialTaskGroup
	{
		private var totalTicks:uint = 0;
		private var ratioMap:Dictionary = new Dictionary(true);
		private var completedProgress:uint = 0;
		
		public function ProgressTaskGroup(label:String = null)
		{
			if (label == null)
				label = "[ProgressTaskGroup]";
			
			setName(label);
			
			setCancelable(true);
			setSuspendable(true);
			setSkippable(false);
			setRestartable(false);
		}
			
		public override function addTask(task:Task):Boolean
		{
			storeTaskRatio(task, 1);
			
			return super.addTask(task);
		}

		public function addTaskRatio(task:Task, ticks:uint):Boolean
		{
			storeTaskRatio(task, ticks);
			
			return super.addTask(task);
		}
		
		public override function removeTask(task:Task):Boolean
		{
			if (task.state == TaskState.INACTIVE)
			{
				var ticks:uint = ratioMap[task];
				totalTicks -= ticks;
				completedProgress -= ticks;
			}
			
			delete ratioMap[task];
			
			return super.removeTask(task);
		}
			
		public override function removeAllTasks():void
		{
			ratioMap = new Dictionary(true);
			totalTicks = 0;
			completedProgress = 0;
			
			super.removeAllTasks();
		}
			
		protected override function startTask(task:Task):void
		{
			var childLabel:String = (task is ProgressTask) ? ProgressTask(task).label : task.toString();
			dispatchCurrentProgress(task, 0, childLabel);
			
			super.startTask(task);
		}
		
		protected override function handleTaskComplete(task:Task):void
		{
			var childLabel:String = (task is ProgressTask) ? ProgressTask(task).label : task.toString();
			dispatchCurrentProgress(task, 1, childLabel);
			
			completedProgress += uint(ratioMap[task]);
			
			super.handleTaskComplete(task);
		}
		
		internal function progressChild(task:Task, progress:Number, childLabel:String):void
		{
			dispatchCurrentProgress(task, progress, childLabel);
		}

		private function dispatchCurrentProgress(task:Task, progress:Number, childLabel:String):void
		{
			var taskPercent:Number = uint(ratioMap[task]) / totalTicks;
			var totalProgress:Number = ((completedProgress / totalTicks) + (progress * taskPercent));

			if (parent != null && parent is ProgressTaskGroup)
				ProgressTaskGroup(parent).progressChild(this, totalProgress, childLabel);
			
			dispatchEvent(new ProgressTaskEvent(ProgressTaskEvent.PROGRESS, totalProgress, childLabel));
		}

		private function storeTaskRatio(task:Task, ticks:int):void
		{
			totalTicks += ticks;
			ratioMap[task] = ticks;
		}
	}
}