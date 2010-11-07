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
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	public class UrlLoaderTask extends AbstractLoaderTask
	{
		protected var _loader:URLLoader;

		public function UrlLoaderTask(fileUrl:String, label:String = null, loader:URLLoader = null)
		{
			super(fileUrl, label);
			
			_loader = (loader == null) ? new URLLoader() : loader;
		}

		public function get loader():URLLoader
		{
			return _loader;
		}

		public override function get data():*
		{
			return _loader.data;
		}

		public override function toString():String
		{
			return "[UrlLoaderTask]";
		}

		protected override function doStart():void
		{
			super.doStart();
			startLoading();
		}

		protected override function doSuspend():void
		{
			stopLoading();
			super.doSuspend();
		}

		protected override function doResume():void
		{
			startLoading();
			super.doResume();
		}

		protected override function doCancel():void
		{
			stopLoading();
			super.doCancel();
		}

		protected override function destroy():void
		{
			removeListener();
			super.destroy();
		}

		protected override function handleComplete(event:Event):void
		{
			complete();
			super.handleComplete(event);
		}

		private function startLoading():void
		{
			addListener();
			_loader.load(new URLRequest(fileUrl));
		}

		private function stopLoading():void
		{
			removeListener();
			
			try
			{
				_loader.close();
			}
			catch (e:Error)
			{
			}
		}

		private function removeListener():void
		{
			_loader.removeEventListener(IOErrorEvent.IO_ERROR, handleError);
			_loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
			_loader.removeEventListener(ProgressEvent.PROGRESS, handleProgress);
			_loader.removeEventListener(Event.COMPLETE, handleComplete);
		}

		private function addListener():void
		{
			_loader.addEventListener(IOErrorEvent.IO_ERROR, handleError);
			_loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
			_loader.addEventListener(ProgressEvent.PROGRESS, handleProgress);
			_loader.addEventListener(Event.COMPLETE, handleComplete);
		}
	}
}