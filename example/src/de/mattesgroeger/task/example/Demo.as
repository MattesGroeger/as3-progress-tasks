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
package de.mattesgroeger.task.example
{
	import de.mattesgroeger.task.example.view.ProgressView;
	import de.mattesgroeger.task.progress.ProgressTaskGroup;
	import de.mattesgroeger.task.progress.events.ProgressTaskEvent;
	import de.mattesgroeger.task.util.FakeProgressTask;

	import org.spicefactory.lib.task.Task;
	import org.spicefactory.lib.task.events.TaskEvent;

	import flash.display.Sprite;

	public class Demo extends Sprite
	{
		private var progressView:ProgressView;
		
		public function Demo()
		{
			initializeProgressDisplay();
			initializeProgressTasks();
		}

		private function initializeProgressDisplay():void
		{
			progressView = new ProgressView();
			addChild(progressView);
			
			progressView.initialize();
		}

		private function initializeProgressTasks():void
		{
			var fake1:Task = new FakeProgressTask("ROOT TASK 1", 300);
			var fake2:Task = new FakeProgressTask("ROOT TASK 2", 900);
			var fakeGroup:Task = getSubGroup();
			
			var taskGroup:ProgressTaskGroup = new ProgressTaskGroup("ROOT");
			taskGroup.ignoreChildErrors = true;
			taskGroup.addEventListener(ProgressTaskEvent.PROGRESS, handleProgress);
			taskGroup.addEventListener(TaskEvent.COMPLETE, handleComplete);
			
			taskGroup.addTaskRatio(fake1, 1);
			taskGroup.addTaskRatio(fakeGroup, 4);
			taskGroup.addTaskRatio(fake2, 3);
			
			taskGroup.start();
		}
		
		private function getSubGroup():ProgressTaskGroup
		{
			var subTaskGroup:ProgressTaskGroup = new ProgressTaskGroup("SUBGROUP");
			
			subTaskGroup.addTask(new FakeProgressTask("SUB TASK 1", 300));
			subTaskGroup.addTask(new FakeProgressTask("SUB TASK 2", 300));
			subTaskGroup.addTask(new FakeProgressTask("SUB TASK 3", 600));
			
			return subTaskGroup;
		}

		private function handleProgress(event:ProgressTaskEvent):void
		{
			progressView.setProgress(event.progress);
			progressView.setLabel(event.label);
		}

		private function handleComplete(event:TaskEvent):void
		{
			progressView.setLabel("COMPLETE");
		}
	}
}

import org.spicefactory.lib.task.Task;

import flash.utils.setTimeout;

class DummyTask extends Task
{
	public function DummyTask(name:String)
	{
		setName(name);
	}

	protected override function doStart():void
	{
		flash.utils.setTimeout(complete, 1000);
	}
}