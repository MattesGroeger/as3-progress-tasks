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
package de.mattesgroeger.task.util
{
	import de.mattesgroeger.task.progress.ProgressTask;

	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.ProgressEvent;

	public class AbstractLoaderTask extends ProgressTask
	{
		protected var _fileUrl:String;

		public function AbstractLoaderTask(fileUrl:String, label:String = null):void
		{
			_fileUrl = fileUrl;

			setCancelable(true);
			setSuspendable(true);
			setSkippable(false);
			setRestartable(false);

			super(label);
		}

		public function get fileUrl():String
		{
			return _fileUrl;
		}
			
		public override function toString():String
		{
			return label;
		}
		
		protected override function doSuspend():void
		{
			progress(0);
		}

		protected override function doResume():void
		{
			progress(0);
		}

		protected override function doCancel():void
		{
			progress(1);
			doDestroy();
		}

		protected override function doError(message:String):void
		{
			trace(message);
			
			progress(1);
			doDestroy();
		}

		protected function handleError(event:ErrorEvent):void
		{
			error("Error loading " + _fileUrl + ": " + event.text);
		}

		protected function handleProgress(progressEvent:ProgressEvent):void
		{
			if (progressEvent.bytesTotal == 0)
				progress(0);
			else
				progress(progressEvent.bytesLoaded / progressEvent.bytesTotal);
		}

		protected function handleComplete(event:Event):void
		{
			doComplete();
			complete();
			doDestroy();
		}

		protected function doComplete():void
		{
			// abstract
		}

		protected function doDestroy():void
		{
			// abstract
		}
	}
}