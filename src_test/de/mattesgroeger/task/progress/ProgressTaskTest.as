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
	import org.flexunit.asserts.fail;
	import org.flexunit.async.Async;
	import org.spicefactory.lib.errors.IllegalArgumentError;

	public class ProgressTaskTest
	{
		[Test]
		public function test_creation():void
		{
			var task:ProgressTask = new ProgressTask("test");

			assertEquals("test", task.label);
		}

		[Test]
		public function test_invalid_progress_values():void
		{
			assertInvalidProgress(-2);
			assertInvalidProgress(1.1);
		}

		private function assertInvalidProgress(progress:Number):void
		{
			var task:MockProgressTask = new MockProgressTask("test");
			
			try
			{
				task.setProgress(progress);
			}
			catch (e:IllegalArgumentError)
			{
				return;
			}
			
			fail("Illegal progress error expected");
		}

		[Test(async)]
		public function test_progress_dispatch():void
		{
			var expectedLabel:String = "test";
			var expectedProgress:Number = 0.3;
			
			var task:MockProgressTask = new MockProgressTask(expectedLabel);
			task.addEventListener(ProgressTaskEvent.PROGRESS, Async.asyncHandler(this, handleProgress, 10, {expectedLabel:expectedLabel, expectedProgress:expectedProgress}));
			
			task.setProgress(expectedProgress);
		}

		private function handleProgress(event:ProgressTaskEvent, passThroughData:Object):void
		{
			assertEquals(passThroughData["expectedProgress"], event.progress);
			assertEquals(passThroughData["expectedLabel"], event.label);
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

	public function setProgress(value:Number):void
	{
		progress(value);
	}
}