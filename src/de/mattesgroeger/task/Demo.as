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
package de.mattesgroeger.task
{
	import de.mattesgroeger.task.progress.ProgressTaskGroup;
	import de.mattesgroeger.task.progress.events.ProgressTaskEvent;
	import de.mattesgroeger.task.util.FakeProgressTask;

	import org.spicefactory.lib.task.Task;
	import org.spicefactory.lib.task.events.TaskEvent;

	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class Demo extends Sprite
	{
		private var targetScale:Number = 0;
		
		private var progressShape:Shape;
		private var progressPercent:TextField;
		private var progressLabel:TextField;
		
		public function Demo()
		{
			initializeProgressDisplay();
			initializeProgressTasks();
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

		private function initializeProgressDisplay():void
		{
			progressShape = new Shape();
			progressShape.graphics.beginFill(0);
			progressShape.graphics.drawRect(0, 67, stage.stageWidth, 2);
			progressShape.graphics.endFill();
			progressShape.scaleX = 0;
			addChild(progressShape);
			
			progressLabel = createTextField(20, false, 0x666666);
			progressLabel.y = 45;
			addChild(progressLabel);
			
			progressPercent = createTextField(150, true, 0x333333);
			progressPercent.x = -3;
			progressPercent.y = 45;
			addChild(progressPercent);
			
			addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}

		private function createTextField(fontSize:uint, bold:Boolean, color:uint):TextField
		{
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "Arial";
			textFormat.size = fontSize;
			textFormat.color = color;
			textFormat.bold = bold;
			
			var textField:TextField = new TextField();
			textField.defaultTextFormat = textFormat;
			textField.autoSize = TextFieldAutoSize.LEFT;
			
			return textField;
		}

		private function handleEnterFrame(event:Event):void
		{
			progressShape.scaleX += (targetScale - progressShape.scaleX) / 2;
		}

		private function handleProgress(event:ProgressTaskEvent):void
		{
			progressPercent.text = String(Math.round(event.progress * 100));
			targetScale = event.progress;
			
			progressLabel.text = event.label;
		}

		private function handleComplete(event:TaskEvent):void
		{
			progressLabel.text = "COMPLETE";
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