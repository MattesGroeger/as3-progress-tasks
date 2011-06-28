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
package de.mattesgroeger.task.util
{
	import org.flexunit.asserts.assertNotNull;
	import org.flexunit.async.Async;
	import org.spicefactory.lib.task.events.TaskEvent;

	public class CssLoaderTaskTest
	{
		[Test(async)]
		public function test_loading():void
		{
			var loader:CssLoaderTask = new CssLoaderTask("assets/dummy.css");

			loader.addEventListener(TaskEvent.COMPLETE, Async.asyncHandler(this, handleFileComplete, 1000));
			loader.start();
		}

		private function handleFileComplete(event:TaskEvent, passThrougData:Object):void
		{
			var task:CssLoaderTask = CssLoaderTask(event.target);

			assertNotNull(task.styleSheet);
			assertNotNull(task.styleSheet.getStyle("bluetext"));
		}
	}
}
