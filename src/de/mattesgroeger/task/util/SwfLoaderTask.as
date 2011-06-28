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
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	public class SwfLoaderTask extends AbstractLoaderTask
	{
		protected var _loader:Loader;
		protected var _loaderContext:LoaderContext;
		protected var _container:DisplayObjectContainer;

		public function SwfLoaderTask(fileUrl:String, label:String = null, context:LoaderContext = null, loader:Loader = null, targetContainer:DisplayObjectContainer = null):void
		{
			super(fileUrl, label);
			
			setCancelable(true);
			setSuspendable(true);
			setSkippable(false);
			
			_loader = (loader == null) ? new Loader() : loader;
			_loaderContext = context;
			_container = targetContainer;
		}

		public function get loader():Loader
		{
			return _loader;
		}

		public function get loaderContext():LoaderContext
		{
			return _loaderContext;
		}

		public function get width():int
		{
			return _loader.contentLoaderInfo.width;
		}

		public function get height():int
		{
			return _loader.contentLoaderInfo.height;
		}

		public function get content():DisplayObject
		{
			return _loader.content;
		}

		public function get targetContainer():DisplayObjectContainer
		{
			return _container;
		}
		
		protected override function doStart():void
		{
			super.doStart();
			startLoading();
		}

		protected override function doCancel():void
		{
			stopLoading();
			super.doCancel();
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

		protected override function handleComplete(event:Event):void
		{
			if (_container != null) 
				_container.addChild(_loader.content as DisplayObject);
			
			super.handleComplete(event);
		}

		protected override function doDestroy():void
		{
			removeListener();
			super.doDestroy();
		}

		private function startLoading():void
		{
			addListener();
			_loader.load(new URLRequest(fileUrl), _loaderContext);
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

		private function addListener():void
		{
			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleError);
			_loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
			_loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, handleProgress);
			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleComplete);
		}

		private function removeListener():void
		{
			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleError);
			_loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
			_loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, handleProgress);
			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleComplete);
		}
	}
}