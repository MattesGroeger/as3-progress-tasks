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
	import de.mattesgroeger.task.example.tasks.FileTaskGroupFactory;
	import de.mattesgroeger.task.example.tasks.NormalTaskGroupFactory;
	import de.mattesgroeger.task.example.tasks.ProgressTaskGroupFactory;
	import de.mattesgroeger.task.example.tasks.WeightedTaskGroupFactory;
	import de.mattesgroeger.task.example.tasks.SubTaskGroupFactory;
	import de.mattesgroeger.task.example.view.ProgressView;
	import de.mattesgroeger.task.example.view.TaskButtonBar;
	import de.mattesgroeger.task.example.view.TaskPushButton;
	import de.mattesgroeger.task.progress.ProgressTaskGroup;
	import de.mattesgroeger.task.progress.events.ProgressTaskEvent;

	import org.spicefactory.lib.task.events.TaskEvent;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.MouseEvent;

	[SWF(backgroundColor="#cccccc", frameRate="31", width="550", height="200")]
	public class Demo extends Sprite
	{
		private var progressView:ProgressView;
		private var taskGroup:ProgressTaskGroup;

		public function Demo()
		{
			initializeStage();
			initializeButtonBar();
			initializeProgressDisplay();
		}

		private function initializeStage():void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
		}

		private function initializeButtonBar():void
		{
			var buttonBar:TaskButtonBar = new TaskButtonBar();
			buttonBar.addEventListener(MouseEvent.CLICK, handleButtonBarClick);

			buttonBar.addButton(new NormalTaskGroupFactory(), "Normal Tasks");
			buttonBar.addButton(new WeightedTaskGroupFactory(), "Weighted Tasks");
			buttonBar.addButton(new SubTaskGroupFactory(), "SubGroup Tasks");
			buttonBar.addButton(new FileTaskGroupFactory(), "File Loader Tasks");

			addChild(buttonBar);
		}

		private function initializeProgressDisplay():void
		{
			progressView = new ProgressView();
			addChild(progressView);

			progressView.initialize();
		}

		private function handleButtonBarClick(event:MouseEvent):void
		{
			if (taskGroup != null)
				resetOldTaskGroup();

			initializeNewTaskGroup(TaskPushButton(event.target).factory);
		}

		private function resetOldTaskGroup():void
		{
			progressView.reset();

			taskGroup.removeEventListener(ProgressTaskEvent.PROGRESS, handleProgress);
			taskGroup.removeEventListener(TaskEvent.COMPLETE, handleComplete);
			taskGroup.cancel();
		}

		private function initializeNewTaskGroup(factory:ProgressTaskGroupFactory):void
		{
			taskGroup = factory.create();

			taskGroup.ignoreChildErrors = true;
			taskGroup.addEventListener(ProgressTaskEvent.PROGRESS, handleProgress);
			taskGroup.addEventListener(TaskEvent.COMPLETE, handleComplete);

			taskGroup.start();
		}

		private function handleProgress(event:ProgressTaskEvent):void
		{
			progressView.setProgress(event.progress);
			progressView.setLabel(event.label);
		}

		private function handleComplete(event:TaskEvent):void
		{
			progressView.setLabel("FINISHED");
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