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

	import org.flexunit.asserts.assertEquals;
	import org.flexunit.async.Async;

	public class SequentialProgressTaskGroupTest
	{
		private var callTimer:uint = 0;

		[Before]
		public function tearUp():void
		{
			callTimer = 0;
		}

		[After]
		public function tearDown():void
		{
			callTimer = 0;
		}

		[Test(async)]
		public function test_normal_progress():void
		{
			var group:SequentialProgressTaskGroup = new SequentialProgressTaskGroup();
			group.addTask(new MockProgressTask("task1"));
			group.addTask(new MockProgressTask("task2"));

			assertGroupProgress(group, [0, 	 0.25, 0.5, 
										0.5, 0.75, 1], 
									   ["task1", "task1", "task1", 
									   	"task2", "task2", "task2"]);
		}

		[Test(async)]
		public function test_sub_group_progress():void
		{
			var subGroup:SequentialProgressTaskGroup = new SequentialProgressTaskGroup();
			subGroup.addTask(new MockProgressTask("task2"));

			var group:SequentialProgressTaskGroup = new SequentialProgressTaskGroup();
			group.addTask(new MockProgressTask("task1"));
			group.addTask(subGroup);

			assertGroupProgress(group, [0, 	 0.25, 0.5, 
										0.5, 0.75, 1], 
									   ["task1", "task1", "task1", 
									   	"task2", "task2", "task2"]);
		}

		[Test(async)]
		public function test_weighted_progress():void
		{
			var group:SequentialProgressTaskGroup = new SequentialProgressTaskGroup();
			group.addTaskWeighted(new MockProgressTask("task1"), 25);
			group.addTaskWeighted(new MockProgressTask("task2"), 75);

			assertGroupProgress(group, [0, 	  0.125, 0.25, 
										0.25, 0.625, 1], 
									   ["task1", "task1", "task1", 
									   	"task2", "task2", "task2"]);
		}

		[Test(async)]
		public function test_sub_group_weighted_progress():void
		{
			var subGroup:SequentialProgressTaskGroup = new SequentialProgressTaskGroup();
			subGroup.addTask(new MockProgressTask("task2"));
			subGroup.addTask(new MockProgressTask("task3"));
			subGroup.addTask(new MockProgressTask("task4"));

			var group:SequentialProgressTaskGroup = new SequentialProgressTaskGroup();
			group.addTaskWeighted(new MockProgressTask("task1"), 25);
			group.addTaskWeighted(subGroup, 75);

			assertGroupProgress(group,  [	0, 0.125, 0.25, 
												0.25, 0.375, 0.5, 
												0.5,  0.625, 0.75, 
												0.75, 0.875, 1], 
										[	"task1", "task1", "task1", 
												"task2", "task2", "task2", 
												"task3", "task3", "task3", 
												"task4", "task4", "task4"]);
		}

		private function assertGroupProgress(group:SequentialProgressTaskGroup, expectedProgress:Array, expectedLabels:Array):void
		{
			group.addEventListener(ProgressTaskEvent.PROGRESS, Async.asyncHandler(this, assertGroupProgressEvent, 100, {group:group, expectedProgress:expectedProgress, expectedLabels:expectedLabels}));
			group.start();
		}

		private function assertGroupProgressEvent(event:ProgressTaskEvent, passThroughObject:Object):void
		{
			var expectedProgress:Array = passThroughObject["expectedProgress"];
			var expectedLabels:Array = passThroughObject["expectedLabels"];
			var group:SequentialProgressTaskGroup = passThroughObject["group"];

			assertEquals(expectedProgress[callTimer], event.progress);
			assertEquals(expectedLabels[callTimer], event.label);

			if (++callTimer < expectedProgress.length)
				group.addEventListener(ProgressTaskEvent.PROGRESS, Async.asyncHandler(this, assertGroupProgressEvent, 100, {group:group, expectedProgress:expectedProgress, expectedLabels:expectedLabels}));
		}
	}
}

import de.mattesgroeger.task.progress.ProgressTask;

class MockProgressTask extends ProgressTask
{
	public function MockProgressTask(label:String)
	{
		super(label);
	}

	protected override function doStart():void
	{
		progress(0.5);
		complete();
	}
}