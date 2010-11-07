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
	import flash.media.Sound;
	import flash.media.SoundLoaderContext;
	import flash.net.URLRequest;

	public class Mp3LoaderTask extends AbstractLoaderTask
	{
		protected var _sound:Sound;
		protected var _soundLoaderContext:SoundLoaderContext;

		public function Mp3LoaderTask(fileUrl:String, taskName:String = null, soundLoaderContext:SoundLoaderContext = null, sound:Sound = null)
		{
			super(fileUrl, taskName);

			_sound = (sound) ? sound : new Sound();
			_soundLoaderContext = soundLoaderContext;

			addListener();
		}

		public function get sound():Sound
		{
			return _sound;
		}

		public function get soundLoaderContext():SoundLoaderContext
		{
			return _soundLoaderContext;
		}

		public override function toString():String
		{
			return "[Mp3LoaderTask]";
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

			_sound.load(new URLRequest(fileUrl), _soundLoaderContext);
		}

		private function stopLoading():void
		{
			removeListener();

			try
			{
				_sound.close();
			}
			catch (e:Error)
			{
			}
		}

		private function addListener():void
		{
			_sound.addEventListener(IOErrorEvent.IO_ERROR, handleError);
			_sound.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
			_sound.addEventListener(ProgressEvent.PROGRESS, handleProgress);
			_sound.addEventListener(Event.COMPLETE, handleComplete);
		}

		private function removeListener():void
		{
			_sound.removeEventListener(IOErrorEvent.IO_ERROR, handleError);
			_sound.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, handleError);
			_sound.removeEventListener(ProgressEvent.PROGRESS, handleProgress);
			_sound.removeEventListener(Event.COMPLETE, handleComplete);
		}
	}
}