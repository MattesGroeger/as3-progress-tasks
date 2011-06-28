/*
 * Copyright (c) 2011 Mattes Groeger
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
	
	[Deprecated(replacement="SequentialProgressTaskGroup", since="0.3.0")]
	public class ProgressTaskGroup extends SequentialTaskGroup implements IProgressTaskGroup
	{
		private var totalWeight:uint = 0;
		private var weightMap:Dictionary = new Dictionary(true);
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
			storeTaskWeighted(task, 1);
			
			return super.addTask(task);
		}

		public function addTaskWeighted(task:Task, weight:uint):Boolean
		{
			storeTaskWeighted(task, weight);
			
			return super.addTask(task);
		}
		
		public override function removeTask(task:Task):Boolean
		{
			if (task.state == TaskState.INACTIVE)
			{
				var weight:uint = weightMap[task];
				totalWeight -= weight;
				completedProgress -= weight;
			}
			
			delete weightMap[task];
			
			return super.removeTask(task);
		}
			
		public override function removeAllTasks():void
		{
			weightMap = new Dictionary(true);
			totalWeight = 0;
			completedProgress = 0;
			
			super.removeAllTasks();
		}
			
		protected override function startTask(task:Task):void
		{
			if (task is ProgressTask)
				dispatchCurrentProgress(task, 0, ProgressTask(task).label);
			
			super.startTask(task);
		}
		
		protected override function handleTaskComplete(task:Task):void
		{
			if (task is ProgressTask) 
				dispatchCurrentProgress(task, 1, ProgressTask(task).label);
			
			completedProgress += uint(weightMap[task]);
			
			super.handleTaskComplete(task);
		}
		
		public function progressChild(task:Task, progress:Number, childLabel:String):void
		{
			dispatchCurrentProgress(task, progress, childLabel);
		}

		private function dispatchCurrentProgress(task:Task, progress:Number, childLabel:String):void
		{
			var taskPercent:Number = uint(weightMap[task]) / totalWeight;
			var totalProgress:Number = ((completedProgress / totalWeight) + (progress * taskPercent));

			if (parent != null && parent is IProgressTaskGroup)
				IProgressTaskGroup(parent).progressChild(this, totalProgress, childLabel);
			
			dispatchEvent(new ProgressTaskEvent(ProgressTaskEvent.PROGRESS, totalProgress, childLabel));
		}

		private function storeTaskWeighted(task:Task, weight:int):void
		{
			totalWeight += weight;
			weightMap[task] = weight;
		}
	}
}